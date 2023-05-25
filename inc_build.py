def update_build():
  with open("./source/pdxinfo", "r") as file:
    data = file.readlines()
  
  for idx, line in enumerate(data):
    if line.startswith("buildNumber"):
      n = int(line.split("=")[1]) + 1
      data[idx] = f"buildNumber={n}\n"
      break

  with open("./source/pdxinfo", "w") as file:
    file.writelines(data)
  

if __name__ == "__main__":
  update_build()