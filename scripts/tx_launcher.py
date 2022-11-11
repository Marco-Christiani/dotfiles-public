from __future__ import annotations

import os
from pathlib import Path
from typing import TYPE_CHECKING

from omegaconf import OmegaConf

if TYPE_CHECKING:
    from typing import List


TX_DIR = Path(os.environ['CONFIG_DIR']).joinpath('tmuxinator')
COMPONENTS_DIR = TX_DIR.joinpath('components')

# def main(*components: List[str]):


def main(project_name, *args, **kwargs):
    project_config = OmegaConf.load(TX_DIR.joinpath(project_name).with_suffix('.yml'))
    components = COMPONENTS_DIR.glob('*.yml')
    for c in components:
        OmegaConf.merge((project_config, c))
    OmegaConf.resolve(project_config)
    print(project_config)


main('composed')


if __name__ == "__main__":
    main()
