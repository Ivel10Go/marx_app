"""
Template: Upload AAB to Google Play using a Service Account.
Requirements:
  pip install google-api-python-client google-auth google-auth-httplib2
Setup:
  1. Create a Google Cloud Service Account and grant it access to your Play Console (API access > Create service account key).
  2. Download the JSON key and save as `secrets/play-service-account.json` (DON'T commit it).
  3. Enable Google Play Developer API for the project.
Usage:
  python tools/upload_aab_template.py --aab build/app/outputs/bundle/release/app-release.aab --package com.example.marx_app

This script performs a simple edit -> upload -> commit flow.
"""
import argparse
import json
import os
from google.oauth2 import service_account
from googleapiclient.discovery import build

SCOPES = ["https://www.googleapis.com/auth/androidpublisher"]


def main():
    p = argparse.ArgumentParser()
    p.add_argument("--aab", required=True)
    p.add_argument("--package", required=True)
    p.add_argument("--key", default="secrets/play-service-account.json")
    args = p.parse_args()

    creds = service_account.Credentials.from_service_account_file(args.key, scopes=SCOPES)
    service = build('androidpublisher', 'v3', credentials=creds)

    edit_request = service.edits().insert(body={}, packageName=args.package)
    edit = edit_request.execute()
    edit_id = edit['id']
    print('Created edit:', edit_id)

    # Upload the bundle
    with open(args.aab, 'rb') as fh:
        bundle_resp = service.edits().bundles().upload(
            packageName=args.package,
            editId=edit_id,
            media_body=args.aab
        ).execute()
    print('Uploaded bundle:', bundle_resp)

    # Assign to internal test track
    track_resp = service.edits().tracks().update(
        packageName=args.package,
        editId=edit_id,
        track='internal',
        body={"releases": [{"name": "Automated upload", "versionCodes": bundle_resp.get('versionCode') and [bundle_resp['versionCode']] or [], "status": "completed"}]}
    ).execute()
    print('Track updated:', track_resp)

    # Commit
    commit_resp = service.edits().commit(packageName=args.package, editId=edit_id).execute()
    print('Edit committed:', commit_resp)


if __name__ == '__main__':
    main()
