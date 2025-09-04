# Section 2: Python closures & scope
def bad_funcs():
    fs = []
    for i in range(3):
        fs.append(lambda x: x + i)  # late binding
    return fs

def good_funcs():
    fs = []
    for i in range(3):
        fs.append(lambda x, i=i: x + i)  # capture value
    return fs

b = [f(10) for f in bad_funcs()]
g = [f(10) for f in good_funcs()]

print("Python bad (late-bound):", b)
print("Python good (captured):", g)
