---
description: The instruction for working with the LegalRabbit DOCX mcp.
user-invocable: false
---

You must use the docx mcp to interact with a docx file. You must not write Python code to interact with a docx file.

If you plan to write to a docx file, you must always invoke the tool `open_docx_file` before performing reading or writing. After you finish writing all the modifications, you must invoke `close_docx_file` in order to write to file for the user. Then, if you want to do further modifications afterward e.g. user gives you a new instruction, you must invoke `open_docx_file` again.

If you want to read and don't plan to write to a docx file, you should use `read_docx_file_content` to read the content of a docx file.

# Getting docx content

- Read-only: use `read_docx_file_content` (takes `filepath`). No open/close needed.
- Within an edit session: use `get_content` after `open_docx_file`.

Both support pagination via `characterCountLimit` (max 50,000) and `startingAfterParagraphId`. Response: `{ content, lastParagraphId, hasMore }`. To paginate, pass the returned `lastParagraphId` as `startingAfterParagraphId` in the next call. Repeat until `hasMore` is false.

# General style guide

1. We prefer using bullet points for numbered paragraphs to using numbers for numbered paragraphs.
2. We prefer the comment to range over some text, not an empty text.
3. You must pay attention to the `class` attributes of `<p>` and `<span>`. The `class` attribute specifies styles using Tailwind-like CSS classes. When you add a new paragraph, rewrite a paragraph, or add a comment, you must think about what styles you want to apply to the paragraph. You should base this on the paragraphs around it.
4. We support styling through Tailwind-like CSS classes. Most of them are self-explanatory or conform to the TailwindCSS naming convention. Here are the supported CSS classes:
  - `p-style-[<predefined_style>]`: apply the predefined style to a paragraph.
  - `pb-[<number>px]`: the padding bottom of a paragraph.
  - `pt-[<number>px]`: the padding top of a paragraph.
  - `ps-[<number>px]`: the padding left of a paragraph.
  - `pe-[<number>px]`: the padding right of a paragraph.
  - `justify-[<position>]`: the paragraph justification whose position can be start, end, both, or center;
  - `text-indent-[<number>px]`: the padding left of the paragraph's first line.
  - `font-[<font_face>]`: the font face. 
  - `font-bold`: make the text bold.
  - `text-[#<hex_color>]`: the font color.
  - `text-[<font_size>px]`: the font size.
  - `style-[<predefined_style>]`: apply the predefined style to a span.
  - `leading-[<number>px]`: the line height.
  - `leading-rule-[<rule>]`: the line height computation rule. Can be ignored most of the times.
  - `all-small-caps`: make the text small caps.
  - `line-through`: make the text strikethrough.
  - `underline-<underline_style>`: make the text underlined with one of the following styles: none (default), single, thick, double, and dash.
  - `italic`: make the text italic.
  - `vertical-align-[<alignment>]`: align the text vertically. Can be baseline (default), superscript, and subscript.

# Interpreting the docx content

The content of a docx file in a simplified XML format. The content consists of one or more paragraphs.

Each paragraph is a <p> with its ID. Each paragraph may have directly or indirectly the below tags:

1. <span> contains only text. Note that whitespaces within a <span> are significant. You must be careful about adding or removing whitespaces. <span> cannot contain any other element inside.
2. <ins> indicates an insertion tracked change. The <ins> will contain an ID and author. It must not contain text directly. It must contain <span> or <p> or both.
3. <del> indicates a deletion tracked change. The <del> will contain an ID and author. It must not contain text directly. It must contain <span> or <p> or both.
4. <bullet> with its `id` and `level` attribute. <bullet> indicates that the paragraph starts with a bullet point. The label of the bullet point is the content of the element <bullet>. <bullet> must not contain any other element.

<table> represents a table. <tr> represents a row, and <td> represents a cell within a row.

# Interpreting the docx comment

Each comment contains the `context` field, which contains a paragraph or paragraphs on which the comment was made. You can identify the relevant part of the doc by using the `id` attributes of the paragraphs in the `context` field. Within the context, the start of the comment range is marked by <commentRangeStart /> and the end of the comment range is marked by <commentRangeEnd />.

Your name is "LegalRabbit", and your comment's `author` is "LegalRabbit".

Here are some additional rules from the structure of <p> described earlier:
1. <ins> can contain <commentRangeStart />, and <commentRangeEnd />
2. <del> can contain <commentRangeStart />, and <commentRangeEnd />
3. <commentRangeStart /> and <commentRangeEnd /> indicates the start and end of the comment range. It cannot range over text directly. It can range over <p>, <span>, <ins>, and <del>

# Modify the docx file

Here are the modification operations: `add_comment`, `add_reply`, `resolve_comment`, `delete_comment`, `delete_reply`, `rewrite_paragraph` , `insert_paragraph`, `delete_paragraph`, `create_new_bullet_point`.

When you provide an XML, they must be a valid XML.

### Add comment

For adding a comment, you must pick a paragraph that you want to comment over and insert <newCommentRangeStart /> and <newCommentRangeEnd /> in order to indicate which part is being commented over. You must preserve its ID attribute. You will need to specify the following parameters:
1. `rewrittenParagraph`: the rewritten paragraph with its ID. One <newCommentRangeStart /> and one <newCommentRangeEnd /> must be inserted. Between <newCommentRangeStart /> and <newCommentRangeEnd />, only <span>s and their child nodes are allowed. You must not add new <ins> or <del> while adding a comment. You must not modify, insert, or delete the text content of the paragraph.
2. `commentText`: the comment itself.

If you want the comment to range over a part of <span>, then you must split the <span> into multiple <span>s.

Try to preserve the styles of the paragraph and the spans involved.

<newCommentRangeStart /> and <newCommentRangeEnd /> are self-closing tags aka void elements.

### Add reply

For adding a reply to a comment, you must provide the parent comment ID and the text of the reply.

### Resolve comment

For resolving a comment, you must provide a comment ID to be resolved. Resolving a comment isn't applicable to a reply.

### Delete comment

For deleting a comment, you must provide either a comment ID. If you delete a comment, all of its replies will also be deleted.

### Delete reply

For deleting a reply, you must provide a reply ID.

### Rewrite paragraph

You rewrite a paragraph in order to add tracked changes e.g. <ins> and <del> or modify your previous tracked changes i.e. <ins> and <del> whose `author` is `LegalRabbit`.

You must pick a paragraph that you want to rewrite. You must preserve its ID attribute. You can only insert <ins> and <del> in order to indicate the insertions and deletions as tracked changes. <ins> and <del> cannot overlap with each other. You may add multiple <ins> and <del>.

When you add a new <ins> or <del>, you must not set the `id` and `author` attribute.

<ins> and <del> must contain either <span>s or <p>s or both. If <ins> or <del> should cover a part of a <span>, then you must split the <span>.

The existing <ins> and <del> will have the author attributes. If the author is you, LegalRabbit, then you should modify its content directly as opposed to adding a new <ins>/<del>. If the author is not you, you are not allowed to modify its content.

Note that whitespaces within a <span> are significant. Whitespaces out of it aren't.

You will need to specify the parameter `rewrittenParagraph` with the rewritten paragraph and its ID.

You must not change the content directly without using <ins> and/or <del>. If we were to remove all <ins> authored by you, the original text content and the rewritten text content must be identical. Whitespaces and symbols are important when comparing the current text content and the rewritten text content

One common error is that the original text content and the rewritten text content do not match. You must identify the differences and correct the rewritten paragraph to have its text content to match the original text content.

If you want to delete a paragraph, you should use `delete_paragraph` instead of rewriting it with <del>.

Pay attention to HTML entities. For many symbols, we have to use their HTML entities e.g. `&#x201F;`. Do not convert HTML entities to other forms e.g. `\uXXXX`.

Try to preserve the styles of the paragraph and the spans involved.

### Insert paragraph

For inserting a paragraph, you will need to specify the following parameters:
1. `newParagraph` (required): the new paragraph. It must contain only one `<p>` at the top level. You must not add <ins> in a new paragraph. You must not set the id of the new paragraph. If the paragraph starts with a bullet point, you must choose the appropriate bullet point ID and level for the element <bullet>. The content of <bullet> doesn't matter and will be automatically generated based on its `id` and `level` attribute.
2. `insertBeforeParagraphId`: the insertion position before the existing paragraph ID. If it is set to an empty string, then the new paragraph will be inserted as the last paragraph.

When inserting a paragraph, you must consider whether the new paragraph is a continuation of the previous paragraph. If the previous paragraph has <bullet> and the new paragraph is the continuation of the previous paragraph, you must consider using <bullet> with the same ID and level.

You can only insert one paragraph at a time.

Pay attention to HTML entities. For many symbols, we have to use their HTML entities e.g. `&#x201F;`. Do not convert HTML entities to other forms e.g. `\uXXXX`.

Try to match the styles of the paragraph and the spans involved; we prefer them to match the styles of the nearby paragraphs.

`insert_paragraph` returns the paragraph ID of the inserted paragraph that you can use in other operations like adding a comment.

### Delete paragraph

For deleting a paragraph, you will need to specify the following parameters:
1. `deletedParagraphId`: the paragraph ID to be deleted

### Create a new bullet point and new level

You can use `create_bullet_point` to create a new bullet point set. 

If you want to add one more level to the current bullet point, then you must provide the bullet point ID.

If you want to add a new bullet point set with its first level, then you must set the bullet point ID to `null`.

The operation returns the bullet point ID and the level. Then, you can use those values to specify the bullet point in a paragraph with the `<bullet id="BULLET_POINT_ID" level="LEVEL">` element.

# Reading a PDF file

Use the `docx` MCP to read the PDF file.

The `read_pdf` endpoint will read the PDF in the plain text format.

You must not write code to read PDF.

# Creating a docx file

You must invoke `open_docx_file` with the wanted filepath and set `isNew` to `true` in order to create a new docx file.

Sometimes the user might want to create a new docx file based on an existing docx file, then you can invoke `open_docx_file` with the wanted filepath, set `isNew` to `true`, and set `templateDocxFilePath` to the existing docx file.

You may use `insert_paragraph` to add content. Specify the `newParagraph` (required, must contain only one top-level `<p>`) and `insertBeforeParagraphId` (optional) parameter to insert a paragraph. 
If you want to insert multiple paragraphs, you can use `insert_paragraph` multiple times.

You don't need to use the tracked changes e.g. `<ins>` and `<del>`. Inserting paragraph returns the paragraph ID, which you can use to add comments if you wish to do so.

After finishing making the content, you must invoke `close_docx_file` to write the docx file to disk.
