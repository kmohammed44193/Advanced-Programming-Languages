# stats_calculator.py

from collections import Counter
from typing import List, Optional


class StatisticsCalculator:
    """
    Computes mean, median, and mode for a list of integers.

    Usage:
        calc = StatisticsCalculator([1, 2, 2, 3])
        calc.mean()   -> 2.0
        calc.median() -> 2.0
        calc.mode()   -> [2]
    """

    def __init__(self, data: List[int]) -> None:
        if not isinstance(data, list) or any(type(x) is not int for x in data):
            raise TypeError("Data must be a list of integers.")
        if len(data) == 0:
            raise ValueError("Data list cannot be empty.")
        self._data = data[:]  # copy to avoid external mutation

    def mean(self) -> float:
        return sum(self._data) / len(self._data)

    def median(self) -> float:
        sorted_data = sorted(self._data)
        n = len(sorted_data)
        mid = n // 2
        if n % 2 == 1:
            return float(sorted_data[mid])
        return (sorted_data[mid - 1] + sorted_data[mid]) / 2.0

    def mode(self) -> List[int]:
        """
        Returns a list of the most frequent value or values in ascending order.
        If all values occur with the same frequency, returns all unique values.
        """
        counts = Counter(self._data)
        max_freq = max(counts.values())
        modes = [val for val, freq in counts.items() if freq == max_freq]
        return sorted(modes)


def parse_ints(s: str) -> List[int]:
    tokens = s.strip().split()
    if not tokens:
        raise ValueError("Please provide at least one integer.")
    try:
        return [int(t) for t in tokens]
    except ValueError as e:
        raise ValueError("Input must be space separated integers.") from e


def main(raw: Optional[str] = None) -> None:
    if raw is None:
        raw = input("Enter space separated integers: ")
    data = parse_ints(raw)
    calc = StatisticsCalculator(data)

    print("Input:", data)
    print(f"Mean  : {calc.mean():.6f}")
    print(f"Median: {calc.median():.6f}")
    print(f"Mode  : {calc.mode()}")


if __name__ == "__main__":
    # Demo runs for quick screenshots
    print("Demo 1")
    main("1 2 2 3 4")
    print("\nDemo 2")
    main("5 1 9 3 7")
    print("\nInteractive")
    # Uncomment the next line to allow manual input
    # main()
