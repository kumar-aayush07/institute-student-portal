HOW TO ADD NOTICES

1. Copy each notice file into this folder: assets/notices/
2. Supported inline preview formats: PDF, PNG, JPG, JPEG, WEBP and GIF.
3. Add one entry for each file in notices.json. The file name must match exactly.
4. The list sorts by the number in the filename, highest first, by default.
   Example: 256.pdf appears before 243.pdf.
5. Use the "Arrange by" menu to sort by notice number, date, title, or manual order.
6. For manual order, set order: 1 for the first notice, 2 for the second, and so on.
7. Replace the example titles/dates and remove any example entry whose file you have not added.

IMPORTANT:
A normal browser page cannot automatically inspect a server folder and discover new files.
The JSON manifest is therefore the simple, secure index that tells the portal which notices
to display. You do not need to edit HTML or CSS when adding notices; just add the file and
its entry in notices.json.

Example entry:
{
  "id": "notice-256",
  "file": "256.pdf",
  "title": "Notice title",
  "category": "Admissions",
  "date": "2026-11-09",
  "description": "One-line summary",
  "order": 1
}

Run the site using VS Code Live Server or another local/web server so fetch() can load notices.json.
