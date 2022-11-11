#!/usr/bin/env python
import argparse
import re

import pyperclip


__version__ = '1.7.2'

VALIDS = '0123456789abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ_-&'


def read_lines(in_file):
    """Returns a list of lines from a input markdown file."""

    with open(in_file, 'r') as inf:
        in_contents = inf.read().split('\n')
    return in_contents


def remove_lines(lines, remove=['[[back to top]', '<a class="mk-toclify"']):
    """Removes existing [back to top] links and <a id> tags."""

    if not remove:
        return lines[:]

    out = []
    for l in lines:
        if l.startswith(remove):
            continue
        out.append(l)

    return out


def slugify_headline(line, remove_dashes=False):
    """
    Takes a header line from a Markdown document and
    returns a tuple of the
        '#'-stripped version of the head line,
        a string version for <a id=''></a> anchor tags,
        and the level of the headline as integer.
    E.g.,
    >>> dashify_headline('### some header lvl3')
    ('Some header lvl3', 'some-header-lvl3', 3)

    """
    line = line.strip().lstrip('- ')
    stripped_right = line.rstrip('#')
    stripped_both = stripped_right.lstrip('#')  # EDITED
    level = len(stripped_right) - len(stripped_both)
    stripped_wspace = stripped_both.strip()

    # character replacements
    replaced_colon = stripped_wspace.replace('.', '')
    replaced_slash = replaced_colon.replace('/', '')
    rem_nonvalids = ''.join([c if c in VALIDS
                             else '-' for c in replaced_slash])

    lowered = rem_nonvalids.lower()
    slugified = re.sub(r'(-)\1+', r'\1', lowered)  # remove duplicate dashes
    slugified = slugified.strip('-')  # strip dashes from start and end

    # exception '&' (double-dash in github)
    slugified = slugified.replace('-&-', '--')

    if remove_dashes:
        slugified = slugified.replace('-', '')

    return [stripped_wspace, slugified, level]


def tag_and_collect(lines, id_tag=True, back_links=False, exclude_h=None, remove_dashes=False):
    """
    Gets headlines from the markdown document and creates anchor tags.

    Keyword arguments:
        lines: a list of sublists where every sublist
            represents a line from a Markdown document.
        id_tag: if true, creates inserts a the <a id> tags (not req. by GitHub)
        back_links: if true, adds "back to top" links below each headline
        exclude_h: header levels to exclude. E.g., [2, 3]
            excludes level 2 and 3 headings.

    Returns a tuple of 2 lists:
        1st list:
            A modified version of the input list where
            <a id="some-header"></a> anchor tags where inserted
            above the header lines (if github is False).

        2nd list:
            A list of 3-value sublists, where the first value
            represents the heading, the second value the string
            that was inserted assigned to the IDs in the anchor tags,
            and the third value is an integer that reprents the headline level.
            E.g.,
            [['some header lvl3', 'some-header-lvl3', 3], ...]

    """
    """
        # Remove code blocks because python comments look like h1 headers
        start_idx = 0
        for i, line in enumerate(lines):
            if line.strip().startswith('```'):
                if not start_idx:
                    start_idx = i
                else:
                    end_idx = i
                    print('Removing'.center(80, '-'))
                    print(out[start_idx:end_idx])
                    print("-"*80)
                    del out[start_idx:end_idx]
                    start_idx = 0
        # Remove leading "- " since that represents blocks in logseq
        for i, line in enumerate(lines):
            if line.strip().startswith('- '):
                out[i] = line.replace('- ', '')
    """
    out_contents = []
    headlines = []
    valid_headers = ['# ', '## ', '### ', '#### ', '##### ', '###### ']
    # list items can contain headers (logseq blocks)
    valid_headers.extend([f'- {h}' for h in valid_headers])
    valid_headers = tuple(valid_headers)
    in_code_block = False
    for l in lines:
        orig_l = l
        saw_headline = False

        orig_len = len(l)
        l = l.lstrip()

        if l.startswith('```'):
            in_code_block = not in_code_block

        if in_code_block:
            continue

        if l.startswith(valid_headers):

            # comply with new markdown standards

            # not a headline if '#' not followed by whitespace '##no-header':
            if not l.strip().lstrip('- ').lstrip('#').startswith(' '):
                continue
            # not a headline if more than 6 '#':
            if len(l) - len(l.strip().lstrip('- ').lstrip('#')) > 6:
                continue
            # headers can be indented by at most 3 spaces:
            if orig_len - len(l) > 3:
                continue

            # ignore empty headers
            if not set(l) - {'#', ' '}:
                continue

            saw_headline = True
            slugified = slugify_headline(l, remove_dashes)

            if not exclude_h or not slugified[-1] in exclude_h:
                if id_tag:
                    id_tag = '<a class="mk-toclify" id="%s"></a>'\
                        % (slugified[1])
                    out_contents.append(id_tag)
                headlines.append(slugified)

        # out_contents.append(l)
        out_contents.append(orig_l)  # This should be unmodified....
        if back_links and saw_headline:
            out_contents.append('[[back to top](#table-of-contents)]')
    return out_contents, headlines


def positioning_headlines(headlines):
    """
    Strips unnecessary whitespaces/tabs if first header is not left-aligned
    """
    left_just = False
    for row in headlines:
        if row[-1] == 1:
            left_just = True
            break
    if not left_just:
        for row in headlines:
            row[-1] -= 1
    return headlines


def nest_toc_tokens(toc_list):
    """Given an unsorted list with errors and skips, return a nested one.
    [{'level': 1}, {'level': 2}]
    =>
    [{'level': 1, 'children': [{'level': 2, 'children': []}]}]
    A wrong list is also converted:
    [{'level': 2}, {'level': 1}]
    =>
    [{'level': 2, 'children': []}, {'level': 1, 'children': []}]
    """

    ordered_list = []
    if len(toc_list):
        # Initialize everything by processing the first entry
        last = toc_list.pop(0)
        last['children'] = []
        levels = [last['level']]
        ordered_list.append(last)
        parents = []

        # Walk the rest nesting the entries properly
        while toc_list:
            t = toc_list.pop(0)
            current_level = t['level']
            t['children'] = []

            # Reduce depth if current level < last item's level
            if current_level < levels[-1]:
                # Pop last level since we know we are less than it
                levels.pop()

                # Pop parents and levels we are less than or equal to
                to_pop = 0
                for p in reversed(parents):
                    if current_level <= p['level']:
                        to_pop += 1
                    else:  # pragma: no cover
                        break
                if to_pop:
                    levels = levels[:-to_pop]
                    parents = parents[:-to_pop]

                # Note current level as last
                levels.append(current_level)

            # Level is the same, so append to
            # the current parent (if available)
            if current_level == levels[-1]:
                (parents[-1]['children'] if parents
                 else ordered_list).append(t)

            # Current level is > last item's level,
            # So make last item a parent and append current as child
            else:
                last['children'].append(t)
                parents.append(last)
                levels.append(current_level)
            last = t

    return ordered_list


def create_toc(headlines, hyperlink=True, top_link=False, no_toc_header=False):
    """
    Creates the table of contents from the headline list
    that was returned by the tag_and_collect function.
    """
    processed = ['# Table of Contents']
    tab = ' '*4
    numbering = False
    if not numbering:
        for line in headlines:
            title = line[0]
            curr_level = line[2]
            toc_entry = tab*(curr_level-1) + f'- {title}'
            processed.append(toc_entry)
    else:
        tree = nest_toc_tokens(headlines)
        # def print_
    return processed


def build_markdown(toc_headlines, body, spacer=0, placeholder=None):
    """
    Returns a string with the Markdown output contents incl.
    the table of contents.

    Keyword arguments:
        toc_headlines: lines for the table of contents
            as created by the create_toc function.
        body: contents of the Markdown file including
            ID-anchor tags as returned by the
            tag_and_collect function.
        spacer: Adds vertical space after the table
            of contents. Height in pixels.
        placeholder: If a placeholder string is provided, the placeholder
            will be replaced by the TOC instead of inserting the TOC at
            the top of the document

    """
    if spacer:
        spacer_line = ['\n<div style="height:%spx;"></div>\n' % (spacer)]
        toc_markdown = "\n".join(toc_headlines + spacer_line)
    else:
        toc_markdown = "\n".join(toc_headlines)

    body_markdown = "\n".join(body).strip()

    if placeholder:
        markdown = body_markdown.replace(placeholder, toc_markdown)
    else:
        markdown = toc_markdown + body_markdown

    return markdown


def output_markdown(markdown_cont, output_file):
    """
    Writes to an output file if `outfile` is a valid path.

    """
    if output_file:
        with open(output_file, 'w') as out:
            out.write(markdown_cont)


def markdown_toclify(input_file, output_file=None, github=False,
                     back_to_top=False, nolink=False,
                     no_toc_header=False, spacer=0, placeholder=None,
                     exclude_h=None, remove_dashes=False,
                     toc_only=True,
                     clipboard=False):
    """ Function to add table of contents to markdown files.

    Parameters
    -----------
      input_file: str
        Path to the markdown input file.

      output_file: str (defaul: None)
        Path to the markdown output file.

      github: bool (default: False)
        Uses GitHub TOC syntax if True.

      back_to_top: bool (default: False)
        Inserts back-to-top links below headings if True.

      nolink: bool (default: False)
        Creates the table of contents without internal links if True.

      no_toc_header: bool (default: False)
        Suppresses the Table of Contents header if True

      spacer: int (default: 0)
        Inserts horizontal space (in pixels) after the table of contents.

      placeholder: str (default: None)
        Inserts the TOC at the placeholder string instead
        of inserting the TOC at the top of the document.

      exclude_h: list (default None)
        Excludes header levels, e.g., if [2, 3], ignores header
        levels 2 and 3 in the TOC.

      remove_dashes: bool (default: False)
        Removes dashes from headline slugs

      toc_only: bool (default: True)
        Return only the TOC

    Returns
    -----------
    cont: str
      Markdown contents including the TOC.

    """
    raw_contents = read_lines(input_file)
    cleaned_contents = remove_lines(raw_contents, remove=(
        '[[back to top]', '<a class="mk-toclify"'))
    processed_contents, raw_headlines = tag_and_collect(
        cleaned_contents,
        id_tag=not github,
        back_links=back_to_top,
        exclude_h=exclude_h,
        remove_dashes=remove_dashes
    )

    # print('Before positioning_headlines...')
    # [print(p) for p in raw_headlines]
    # leftjustified_headlines = positioning_headlines(raw_headlines)
    # print('After positioning_headlines,')
    # [print(p) for p in leftjustified_headlines]
    processed_headlines = create_toc(raw_headlines,
                                     hyperlink=not nolink,
                                     top_link=not nolink and not github,
                                     no_toc_header=no_toc_header)

    # if nolink:
    #     processed_contents = cleaned_contents
    # cont = build_markdown(toc_headlines=processed_headlines,
    #                       body=processed_contents,
    #                       spacer=spacer,
    #                       placeholder=placeholder)

    toc_markdown = "\n".join(processed_headlines)

    if toc_only:
        return toc_markdown

    if output_file:
        output_markdown(cont, output_file)
    return cont


def commandline():

    parser = argparse.ArgumentParser(
        description='Python script that inserts a table of contents\n'
        'into markdown documents and creates the required internal links.',
        epilog="""    Example:
    markdown-toclify.py ~/Desktop/input.md -o ~/Desktop/output.md

    For more information about how internal links in
    HTML and Markdown documents work
    please see:
    "Creating a table of contents with internal
     links in IPython Notebooks and Markdown documents"
    (http://sebastianraschka.com/Articles/2014_ipython_internal_links.html)

    Updates for this script will be available at
    https://github.com/rasbt/markdown-toclify

    """,
        formatter_class=argparse.RawTextHelpFormatter
    )

    parser.add_argument('InputFile',
                        metavar='input.md',
                        help='path to the Markdown input file')
    parser.add_argument('-o', '--output',
                        metavar='output.md',
                        default=None,
                        help='path to the Markdown output file')
    parser.add_argument('-b', '--back_to_top',
                        action='store_true',
                        help='add [back to top] links.')
    parser.add_argument('-g', '--github',
                        action='store_true',
                        help='omits id-anchor tags (recommended for GitHub)')
    parser.add_argument('-s', '--spacer',
                        default=0,
                        type=int,
                        metavar='pixels',
                        help='add horizontal space (in pixels) after the table of contents')
    parser.add_argument('-n', '--nolink',
                        action='store_true',
                        help='create the table of contents without internal links')
    parser.add_argument('-e', '--exclude_h',
                        type=str,
                        default='',
                        help='exclude eading levels, e.g., "2,3" to exclude all level 2 and 3 headings')
    parser.add_argument('--placeholder',
                        type=str,
                        help='inserts TOC at the placeholder string instead of inserting it on top of the document')
    parser.add_argument('--remove_dashes',
                        action='store_true',
                        help='Removes dashes from generated slugs')
    parser.add_argument('--no_toc_header',
                        action='store_true',
                        help='suppresses the Table of Contents header')
    parser.add_argument('-v', '--version',
                        action='version',
                        version='%s' % __version__)

    parser.add_argument('--clipboard',
                        default=True,
                        action='store_true',
                        help='Whether to copy result to clipboard')

    args = parser.parse_args()

    if args.exclude_h:
        exclude_h = [int(i) for i in args.exclude_h.split(',')]
    else:
        exclude_h = None

    cont = markdown_toclify(input_file=args.InputFile,
                            output_file=args.output,
                            github=args.github,
                            back_to_top=args.back_to_top,
                            nolink=args.nolink,
                            no_toc_header=args.no_toc_header,
                            spacer=args.spacer,
                            placeholder=args.placeholder,
                            exclude_h=exclude_h,
                            remove_dashes=args.remove_dashes)

    if args.clipboard:
        pyperclip.copy(cont)

    if not args.output:
        print(cont)


if __name__ == '__main__':
    commandline()
