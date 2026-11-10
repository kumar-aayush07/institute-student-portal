Version 9 — Notices & Announcements

WHAT'S NEW
- Notices navigation opens a dedicated notices section.
- Notice files are stored in assets/notices/.
- PDF and image notices can be previewed inside the dashboard without opening a new tab.
- Search by title, category, description or notice number.
- Default sorting is notice number high-to-low (e.g. 256 before 243).
- Other sorting: number low-to-high, date newest/oldest, title A-Z, and manual order.
- Preview pane shows the selected notice alongside the list.
- The Notices quick-access card on Overview is clickable.

HOW TO ADD A NOTICE
1. Copy the PDF/image into assets/notices/.
2. Add its metadata entry to assets/notices/notices.json.
3. Set file to the exact filename, title, category and date.
4. Refresh the portal. No HTML/CSS edits are needed.

IMPORTANT BROWSER LIMITATION
A browser cannot automatically enumerate files in a website folder. The JSON manifest is used
as a small publication index. Add the file and its entry to notices.json; the portal then sorts
it automatically by the number in the filename. This works on Live Server or a hosted web server.

SUPPORTED PREVIEW: PDF, PNG, JPG, JPEG, WEBP, GIF.
Other file types remain downloadable/openable but do not have an inline preview.

MANUAL ORDER
Set order: 1 for the first item, 2 for the next, etc., then select "Manual order".
