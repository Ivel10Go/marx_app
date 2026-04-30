#!/usr/bin/env python3
import os

# Create the docs directory
docs_dir = r"F:\Levi\flutter_projekts\Marx\marx_app\lib\docs"
os.makedirs(docs_dir, exist_ok=True)
print(f"Successfully created: {docs_dir}")
print(f"Directory exists: {os.path.exists(docs_dir)}")
