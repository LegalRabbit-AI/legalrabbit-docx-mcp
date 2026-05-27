
# MCP Tool References

The legalrabbit-docx MCP tool references.

## Contents

- Reads the content in the read-only mode
- Gets plain-text content
- Gets content
- Gets the template's content
- Gets all comments
- Adds a comment
- Adds reply
- Resolves comment
- Deletes comment
- Deletes reply
- Rewrites a paragraph
- Inserts a paragraph
- Deletes a paragraph
- Gets a paragraph
- Reads a PDF file
- Confirms you have loaded the legalrabbit-docx skill


### Reads the content in the read-only mode

Tool: `read_docx_file_content`
Input params: `filePath` (required), `characterCountLimit`, and `startingAfterParagraphId`

You can get the content of a docx file using the `read_docx_file_content` tool. It supports pagination where you can specify the `characterCountLimit` param (max: 20000) to limit the number of characters returned and the `startingAfterParagraphId` param to start after a specific paragraph. You should set the `characterCountLimit` to `20000`.

The response contains `content`, `lastParagraphId` (for using in the next subsequent `read_docx_file_content` calls), and `hasMore` (indicating whether there is more content to be fetched).

This is a read-only tool. You don't need to invoke `open_docx_file` before using it.

### Gets plain-text content

Tool: `get_plain_text_content`
Input params: `characterCountLimit` and `startingAfterParagraphId`

You can get the plain-text content of a docx file using the `get_plain_text_content` tool. It supports pagination where you can specify the `characterCountLimit` param (max: 20000) to limit the number of characters returned and the `startingAfterParagraphId` param to start after a specific paragraph. You should set the `characterCountLimit` to `20000`.

The response contains `content`, `lastParagraphId` (for using in the next subsequent `get_content` calls), and `has_more` (indicating whether there is more content to be fetched).

`get_plain_text_content` is excellent when you want to review the content of the docx file without formatting.

Each paragraph is prepended with the paragraph ID that looks like `[id: PARAGRAPH_ID]`. You can use the `get_paragraph` tool to get the specific paragraph with its style before performing modifications.

You must invoke `open_docx_file` before using `get_content`.

### Gets content

Tool: `get_content`
Input params: `characterCountLimit` and `startingAfterParagraphId`

You can get the content of a docx file using the `get_content` tool. It supports pagination where you can specify the `characterCountLimit` param (max: 20000) to limit the number of characters returned and the `startingAfterParagraphId` param to start after a specific paragraph. You should set the `characterCountLimit` to `20000`.

The response contains `content`, `lastParagraphId` (for using in the next subsequent `get_content` calls), and `has_more` (indicating whether there is more content to be fetched).

`get_content` returns the content in the simplified markup language that includes styles.

You must invoke `open_docx_file` before using `get_content`.

### Gets the template's content

Tool: `get_template_content`
Input params: none

When you create a new docx file, you can use the `get_template_content` tool to fetch the content of the template. You should read the template to understand how to style paragraphs, bullets, and spans.

You must invoke `open_docx_file` with `isNew` being `true` before using `get_template_content`.

### Gets all comments

Tool: `get_comments`
Input params: none

You can get all comments in a docx file using the `get_comments` tool. The response is a list of comments. To understand a comment, please see the section "Understand comments".

### Adds a comment

Tool: `add_comment`
Input params: `rewrittenParagraph` (required) and `commentText` (required)

For adding a comment, you must pick a paragraph that you want to comment over and insert `<newCommentRangeStart />` and `<newCommentRangeEnd />` to indicate which part is being commented over. You will need to specify the following parameters:
1. `rewrittenParagraph`: the rewritten paragraph with its `id` attribute to indicate which paragraph. One `<newCommentRangeStart />` and one `<newCommentRangeEnd />` must be inserted. Between `<newCommentRangeStart />` and `<newCommentRangeEnd />`, only `<span>`s are allowed. 
2. `commentText`: the comment itself.

If applicable, you should rewrite the paragraph, add  `<ins>`, add `<del>`, and add a comment at the same time.

You should only call the `get_paragraph` tool to get the updated paragraph if you've previously modified the paragraph; otherwise, you should not invoke `get_paragraph`.

If you want the comment to range over a part of `<span>`, then you must split the `<span>` into multiple `<span>`s.

You must pay attention to the styles and try to preserve the styles of the paragraph and the spans involved.

`<newCommentRangeStart />` and `<newCommentRangeEnd />` are self-closing tags aka void elements.

### Adds reply

Tool: `add_reply`
Input params: `replyText` (required) and `parentCommentId` (required)

For adding a reply to a comment, you must provide the parent comment ID and the text of the reply.

### Resolves comment

Tool: `resolve_comment`
Input params: `commentId` (required)

For resolving a comment, you must provide a comment ID to be resolved. Resolving a comment isn't applicable to a reply.

### Deletes comment

Tool: `delete_comment`
Input params: `commentId` (required)

For deleting a comment, you must provide either a comment ID. If you delete a comment, all of its replies will also be deleted.

### Deletes reply

Tool: `delete_reply`
Input params: `replyId` (required)

For deleting a reply, you must provide a reply ID.

### Rewrites a paragraph

Tool: `rewrite_paragraph`
Input params: `rewrittenParagraph` (required)

You rewrite a paragraph to change the content or add/edit `<ins>` and `<del>` or both.

You must pick a paragraph that you want to rewrite. You must preserve the `id` attribute to indicate which paragraph you want to rewrite.

When you add a new `<ins>` or `<del>`, you must not set the `id` and `author` attribute. `<ins>` and `<del>` must contain `<span>`s. If `<ins>` or `<del>` should cover a part of a `<span>`, then you must split the `<span>`.

The existing `<ins>` and `<del>` will have the `author` attributes. If `author` is `LegalRabbit`, then you should modify its content directly as opposed to adding a new `<ins>` or `<del>`.

Note that whitespaces and tabs within a `<span>` are significant.

One common error is that the original text content and the rewritten text content do not match. You must identify the differences and correct the rewritten paragraph to have its text content to match the original text content.

If you want to delete a paragraph, you should use the `delete_paragraph` tool instead of rewriting it with `<del>`.

Pay attention to HTML entities. For many symbols, we have to use their HTML entities e.g. `&#x201F;`. Do not convert HTML entities to other forms e.g. `\uXXXX`.

Try to preserve the styles of the paragraph and the spans involved.

### Inserts a paragraph

Tool: `insert_paragraph`
Input params: `newParagraphs` (required), `insertBeforeParagraphId` (optional), `insertAfterParagraphId` (optional)

For inserting one or more paragraphs, you will need to specify the following parameters:
1. `newParagraphs` (required): the new paragraphs. It must contain one or more top-level `<p>`s without the `id` attribute. If a paragraph starts with a bullet point, you must choose the appropriate `id` and `level` attribute for `<bullet>`; both attributes must not be `null`. The content of `<bullet>` will be automatically generated based on its `id` and `level` attribute.
2. `insertBeforeParagraphId`: the insertion position before the existing paragraph or gap ID. If it is set to `null` or not specified, then this param isn't used. You must never set this param to an empty string.
3. `insertAfterParagraphId`: the insertion position after the existing paragraph or gap ID. If it is set to `null` or not specified, then this param isn't used. You must never set this param to an empty string.

If both `insertBeforeParagraphId` and `insertAfterParagraphId` are `null`, then the paragraph will be inserted as the last paragraph. `insertBeforeParagraphId` and `insertAfterParagraphId` cannot be both specified with non-null values at the same time.

You must not use `<ins>` or `<del>` when inserting a new paragraph. You must not set the `id` attribute of a new paragraph.

When inserting a paragraph, you must consider whether the new paragraph is a continuation of the previous paragraph. If the previous paragraph has `<bullet>` and the new paragraph is the continuation of the previous paragraph, you must consider using `<bullet>` with the same ID and level.

Pay attention to HTML entities. For many symbols, we have to use their HTML entities e.g. `&#x201F;`. Do not convert HTML entities to other forms e.g. `\uXXXX`.

Try to match the styles of the paragraph and the spans involved; we prefer them to match the styles of the nearby paragraphs. You must decide the appropriate styles of `<bullet>` by setting its `class` attribute if there is a bullet point.

`insert_paragraph` returns the paragraph IDs of the inserted paragraphs that you can use in other operations like adding a comment.

### Deletes a paragraph

Tool: `delete_paragraph`
Input params: `deletedParagraphId` (required)

For deleting a paragraph, you will need to specify the following parameters:
1. `deletedParagraphId`: the paragraph ID to be deleted

### Create a bullet point level

Tool: `create_bullet_point`
Input params: `bulletPointId` (required) and `numberFormat` (required)

You can create a new bullet point level. 

If you want to add one more level to the current bullet point, then you must provide the bullet point ID.

If you want to add a new bullet point set with its first level, then you must set the bullet point ID to `null`.

`numberFormat` is one of the following values: 'decimal', 'lowerLetter', 'upperLetter', 'lowerRoman', and 'upperRoman'

The operation returns the bullet point ID and the level. Then, you can use those values to specify the bullet point in a paragraph with the `<bullet id="BULLET_POINT_ID" level="LEVEL">` element.

### Gets a paragraph

Tool: `get_paragraph`
Input params: `paragraphId` (required)

Getting a paragraph by ID is useful when you want to add a comment over a paragraph that has already been rewritten.

The result will also contain the surrounding `<gap>`s if exists. This helps indicate how the surrounding gaps of the paragraph are implemented.

### Reads a PDF file

Tool: `read_pdf`
Input params: `filePath` (required)

The `read_pdf` endpoint will read the PDF in the plain text format.

You must not write code to read PDF.

### Confirms you have loaded the legalrabbit-docx skill

Tool: `i_have_loaded_the_legalrabbit_docx_skill`
Input params: `password` (required)

You must call the `i_have_loaded_the_legalrabbit_docx_skill` tool before using any other tool in the legalrabbit-docx MCP. You only need to call it once per session.

This is to ensure that you've loaded the legalrabbit-docx skill. In the past, sometimes you forgot to load the legalrabbit-docx skill.

The `password` must be `Cogito, ergo sum`.