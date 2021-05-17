
f = open("./submit.txt", "r")
lines = f.readlines()
for line in lines:
  its = line[:-1].split(" ")
  if(len(line) ==1):
    break
  ans = ["0x"+it+"," for it in its]
  for it in ans[1:]:
    print(it, end="")
  print()