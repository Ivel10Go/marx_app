import os
import shutil

# Create docs directory
docs_dir = "lib/docs"
os.makedirs(docs_dir, exist_ok=True)

# Files to move
files = [
    "FIREBASE_SETUP.md",
    "REVENUECAT_SETUP.md",
    "ADMOB_SETUP.md",
    "AFFILIATE_SETUP.md"
]

# Move files
for file in files:
    src = file
    dst = os.path.join(docs_dir, file)
    if os.path.exists(src):
        shutil.move(src, dst)
        print(f"Moved {src} to {dst}")
    else:
        print(f"File {src} not found")

print("Done!")
