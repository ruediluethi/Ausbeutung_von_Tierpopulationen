def frange(start, stop, step=1, steps=None):
    if steps:
        step = (stop-start)/steps
    n = start
    while n < stop:
        yield n
        n += step

if __name__ == '__main__':
    print(list(frange(2, 5, steps=10)))