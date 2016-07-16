print("running .pythonrc.py...")

try:
    from pprint import pprint as pp
    print("pp()   -> Pretty-print a Python object to a stream [default is sys.stdout].")
except ImportError:
    print ("Module pprint not available")

try:
    import sys
    sys.dont_write_bytecode = True
except ImportError:
    print("Module sys not available")
