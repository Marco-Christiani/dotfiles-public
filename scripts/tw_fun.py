import random
import shlex
import subprocess
import time

from rich.live import Live
from rich.table import Table


def example():
    result = subprocess.run(
        ['exa', '-al', '--colour=always', '/home/marco/scripts'], capture_output=True)
    print(result.stdout)
    print(result.stdout.decode())


def tw_report(report_name: str):
    cmd = shlex.split(f'task rc._forcecolor=on {report_name}')
    result = subprocess.run(cmd, capture_output=True)
    return result.stdout.decode('utf-8')


def generate_table() -> Table:
    """Make a new table."""
    table = Table()
    table.add_column("ID")
    table.add_column("Value")
    table.add_column("Status")

    for row in range(random.randint(2, 6)):
        value = random.random() * 100
        table.add_row(
            f"{row}", f"{value:3.2f}", "[red]ERROR" if value < 50 else "[green]SUCCESS"
        )
    return table


if __name__ == "__main__":
    with Live(generate_table(), refresh_per_second=4) as live:
        for _ in range(40):
            time.sleep(0.4)
            live.update(generate_table())
    # summary_report = tw_report('summary')
    # print(summary_report)

    # ghistory_report = tw_report('ghistory')
    # print(ghistory_report)
