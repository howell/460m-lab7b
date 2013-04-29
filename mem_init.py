# create dummy values in file 
fname = "mem.hex"
# open file for writing
f = open(fname, "w")
# write 128 lines of 5A5A
for i in range(0,128):
    f.write("5A5A5A5A\n")
f.close()
