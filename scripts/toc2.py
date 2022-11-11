from rich import print
from rich.console import Console
from rich.syntax import Syntax


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


def print_as_yaml(s):
    console = Console()
    syntax = Syntax(s, "yaml")
    console.print(syntax)


toc_list = [{'level': 1, 'title': 'this'},
            {'level': 2, 'title': 'that'},
            {'level': 2, 'title': 'that\'s sibling'},
            {'level': 2, 'title': 'that\'s other sibling'},
            {'level': 3, 'title': 'that\'s child'},
            {'level': 3, 'title': 'that\'s child\'s sibling'},
            {'level': 1, 'title': 'another'}
            ]

# print_as_yaml(nest_toc_tokens(toc_list))
result = nest_toc_tokens(toc_list)
print(result)


def process_children(subtree):
    # TODO: This should be recurive and i know it but i am in denial
    parent_level = subtree['level']
    for i in range(len(subtree['children'])):
        child = subtree['children'][i]
        child_level = child['level']
        title = child['title']
        title = f'{parent_level}.{child_level} {title}'
        subtree['children'][i]['title'] = title
    return subtree


# print()
# print(process_children(result[0]))


def get_title(item):
    if not item['children']:
        # this is a leaf node
        # TODO: There could be several sibling leaf nodes
        return item['level']
    for i, child in enumerate(item['children']):
        suffix = get_title(child)
        child['title'] = f'{item["level"]}.{suffix}.{i} {child["title"]}'
        print(child['title'])


result0 = result[0].copy()
get_title(result0)
print(result0)
