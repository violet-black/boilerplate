def sum_values(a: int, b: int) -> int:
    """Sum two values.

    This is an exaggerated example. Do not document *obvious* things in your
    docstrings and params section!!! Try to use type hinting instead.

    Use doctests whenever possible.

    >>> sum_values(40, 2)
    42

    >>> sum_values('42', 2)   # doctest: +IGNORE_EXCEPTION_DETAIL
    Traceback (most recent call last):
    ...
    TypeError:

    :param a: first value
    :param b: second value
    :returns: sum of two values
    """
    return a + b
