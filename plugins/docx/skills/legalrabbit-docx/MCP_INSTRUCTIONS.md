# The legalrabbit-docx MCP

First, you must familiarize yourself with the "Understand the simplified markup language" and "Understand comments" sections. You must refer to the section "MCP Tool References" on how to use the legalrabbit-docx MCP.

Before using any tool, you must choose the correct MCP server. See: "Chooses which MCP server to use". Then, you must call the `initialize` tool with a designated signature (you must read the `initialize` MCP reference for the signature) to confirm that you have loaded the legalrabbit-docx skill.

You must not perform any tool calls in parallel. You must perform one tool call at a time.

## Contents

- Chooses which MCP server to use
- Understands the simplified markup language
- Understands comments
- Reads docx content in the read-only mode
- Reviews a docx file
- Redlines an existing docx file (the redline mode)
- Creates a new docx file (the draft mode)
- Inserts a new paragraph and handles its surrounding gaps
- Handles an MCP tool error
- MCP Tool References
-
## Chooses which MCP server to use

You must choose which MCP server to use based on 2 factors: (1) Whether you are Claude or Codex and (2) whether you run on MacOS or Windows.

For Claude on MacOS, use legalrabbit-docx-enterprise.

For Codex on MacOS, use legalrabbit-docx-discovery.

For Claude on Windows, use legalrabbit-docx-voyager.

For Codex on Windows, use legalrabbit-docx-defiant.

## Understands the simplified markup language

The legalrabbit-docx MCP transforms a docx file into a simplified HTML-like markup language.

Here are the supported tags:
1. `<p>` represents a paragraph. It contains zero or one `<bullet>` and zero or more `<span>`s. It has the `id` attribute and optionally the `class` attribute, which represents its styles.
2. `<bullet>` represents a bullet point and contains a label. It has the `id` (represents the bullet ID), `level` (represents the bullet level), and `class` (represents the style) attributes. It must not contain any other element.
3. `<span>` represents a piece of text within a paragraph. It can optionally has the `class` attribute, which represents its styles. It must not contain any other element. It can only contain text. Whitespaces and tabs are significant inside `<span>`.
4. `<table>`, `<tr>`, `<td>` represents a table, a row, and a cell within a row. Table isn't supported when creating a new docx file.
5. `<ins>` represents a tracked insertion. It can contain `<span>`s and/or `<p>`s. It has the `id`, `author`, and `date` attributes.
6. `<del>` represents a tracked deletion. It can contain `<span>`s and/or `<p>`s. It has the `id`, `author`, and `date` attributes.
7. `<gap />` represents an empty paragraph. Many docx files use one or more `<gap />` to represents the gap between 2 paragraphs. It can contain the `class` attribute, which represents the style.

The styles are represented by the `class` attribute. Here are the supported CSS classes:
- `p-style-[<predefined_style>]`: apply the predefined style to a paragraph. The `predefined_style` name is often self-explanatory.
- `pb-[<number>px]`: the padding bottom of a paragraph.
- `pt-[<number>px]`: the padding top of a paragraph.
- `ps-[<number>px]`: the padding left of a paragraph.
- `pe-[<number>px]`: the padding right of a paragraph.
- `justify-[<position>]`: the paragraph justification whose position can be start, end, both, or center;
- `text-indent-[<number>px]`: the indentation of the paragraph's first line.
- `text-unindent-[<number>px]`: the un-indentation of the paragraph's first line. This supersedes `text-indent-[<number>px]`.
- `font-[<font_face>]`: the font face.
- `font-theme-[<theme_name>]`: the theme of the font.
- `font-bold`: make the text bold.
- `color-[#<hex_color>]`: the font color.
- `color-theme-[<theme_name>]`: the theme color of the text.
- `font-size-[<font_size>px]`: the font size.
- `style-[<predefined_style>]`: apply the predefined style to a span.
- `leading-[<number>px]`: the line height.
- `leading-rule-[<rule>]`: the line height computation rule. Can be ignored most of the times.
- `all-small-caps`: make the text small caps.
- `line-through`: make the text strikethrough.
- `underline-[<underline_style>]`: make the text underlined with one of the following styles: none (default), single, thick, double, and dash.
- `italic`: make the text italic.
- `vertical-align-[<alignment>]`: align the text vertically. Can be baseline (default), superscript, and subscript.

Sometimes a docx file might use one or more empty paragraph as a gap. When inserting a paragraph, you must pay attention to the padding top and bottom whether to insert one empty paragraphs or use `pt-[<number>px]` and `pb-[<number>px>]` or both. As a general rule, you should follow what the nearby paragraphs do.

We should not separate sentences into different `<span>`s if those `<span>`s have identical styles. You must think whether to add one or more whitespaces at the beginning and end of a `<span>` in order to separate sentences properly.

## Understands comments

You can use the `get_comments` tool to read the comments in a docx file.

A comment may have one or more replies. Here's the comment structure:

- `id`: the ID of the comment
- `text`: the text of the comment
- `author`: the author of the comment. If the `author` is `LegalRabbit`, then it is your own comment.
- `date`: the date and time when the comment was created
- `commentedOverText`: the part of the doc where the comment was made over.
- `relevantParagraphs`: the paragraphs that contains the `commentedOverText`. This helps you understand the context of the comment.
- `replies`: a list of replies to the comment. Each reply has the same structure as the comment except for `replies`, `commentedOverText`, and `relevantParagraphs`

You can delete a comment or a reply by using the `delete_comment` or `delete_reply` tool. You can resolve a comment by using the `resolve_comment` tool.

## Reads docx content in the read-only mode

Sometimes you may want to read the plain-text content of a docx file without modifying it. You can use the `read_docx_file_content` tool to do so without going through the flow of opening, getting content, and closing a docx file.

## Reviews a docx file

Sometimes you may want to review the content of a docx file, you should call the `get_plain_text_content` tool because the returned content would be in plain-text without styles and formatting.

Once you've reviewed the content and know what modifications you would like to do, you can use the `get_paragraph` tool to get a specific paragraph in the simplified markup language. Then, you can use `rewrite_paragraph`, `add_comment`, and other tools to modify the paragraph.

## Redlines a docx file (the redline mode)

When you want to manipulate an existing docx file (e.g. editing, redlining, adding a comment), you must first use the `open_docx_file` tool to open the docx file.

Then, you can use the tools like `get_markup_content` and `get_comments` to read the markup content, which has styles, and comments of the docx file. Then, you can use the tools like `add_comment`, `rewrite_paragraph`, `insert_paragraph`, and many more to modify the docx file.

When manipulating the docx file, you are forbidden to change the content of the docx file. You can only add comments/replies, resolve comments, delete comments/replies, redline, or perform other read-only operations.

Redlining means to change the content by rewriting paragraphs and using the `<ins>` tag (insert content) or the `<del>` tag (delete content). `<ins>` and `<del>` have the `author` attributes. You are only allowed to change `<ins>` and `<del>` whose `author` is `LegalRabbit`.

If you accidentally perform a direct content change, the legalrabbit-docx MCP will raise an appropriate exception.

If you want to insert a new paragraph or delete a paragraph, you must use `insert_paragraph` or `delete_paragraph` respectively without using `<ins>` or `<del>`. For `insert_paragraph` and `delete_paragraph`, `<ins>` and `<del>` are automatically inserted in the redline mode. Therefore, you don't need to do so.

After finishing with your manipulation, you must use the `close_docx_file` tool to write the changes to disk and close the docx file.

## Creates a new docx file

To create a new docx file, you can use the `open_docx_file` tool with the `isNew` parameter set to `true` and optionally specify the `templateDocxFilePath` parameter to use an existing docx file as a template. If you don't specify the template, then a default template will be used.

The new docx will inherit the styles from the template. Therefore, you must first use the `get_template_content` tool to understand its styles, so you can use appropriate styles when you insert new paragraphs.

The bullet point levels from the template are copied over to the new doc. Therefore, you can refer to a bullet point level's ID and level from the template without creating one.

The new docx will have empty content. You can use the tools like `insert_paragraph` to insert new paragraphs.  You must pay attention to the styles of the paragraphs, spans, and bullet points. You must ensure the styles match the template's styles.

When creating the docx file, you are allowed to change the content of the docx file directly. You are also allowed to redline when appropriate.

After finishing with your operations, you must use the `close_docx_file` tool to write the changes to disk and close the docx file.

## Handles an MCP tool error

You must understand the error message before retrying.

Here are some common errors:
- Missing input parameters. Then, you must specify the input parameters.
- Invalid markup. Sometimes a certain tag isn't allowed inside another tag. Sometimes a certain tag is a self-closing tag.
- Forbidden direct content change. Sometimes direct content change isn't allowed. You may need to use `<ins>` or `<del>` instead.

You must re-read the reference for the MCP tool again to ensure you specify the parameters correctly.

When retrying, you should not specify the same parameters with the same values. You should try a new set of params and values.

Do not retry more than 3 times. If you cannot overcome the error, you must stop.

If the error persists, please tell the user to update to (1) a new version by visiting https://github.com/LegalRabbit-AI/legalrabbit-docx-claude-plugin and/or (2) email LegalRabbit at tanin@legalrabbit.ai.

## MCP Tool References

The legalrabbit-docx MCP tool references. Here are the list of all tools:

- Reads the content in the read-only mode
- Opens a docx file
- Closes a docx file
- Gets the plain-text content
- Gets the markup content
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

You can get the plain-text content of a docx file using the `read_docx_file_content` tool. It supports pagination where you can specify the `characterCountLimit` param (max: 20000) to limit the number of characters returned and the `startingAfterParagraphId` param to start after a specific paragraph. You should set the `characterCountLimit` to `20000`.

Each paragraph is prepended with the paragraph ID that looks like `[id: PARAGRAPH_ID]`. You can use the `get_paragraph` tool to get the specific paragraph with its style before performing modifications. The paragraph may contain <ins> and <del> to indicate tracked insertions and deletions.

The response contains `content`, `lastParagraphId` (for using in the next subsequent `read_docx_file_content` calls), and `hasMore` (indicating whether there is more content to be fetched).

This is a read-only tool. You don't need to invoke `open_docx_file` before using it.

### Opens a docx file

Tool: `open_docx_file`
Input params: `filePath` (required), `isNew`, and `templateFilePath`

You must specify the `filePath` param to specify where the docx file locates.

If you set `isNew` to `true`, then a new file will be created, and the draft mode will be used. If you set `isNew` to `false` or don't specify `isNew`, then the redline mode will be used.

In the draft mode, you can specify the `templateFilePath` in order to copy the styles from that file. If you don't specify the template file path, then the default template will be used.

### Closes a docx file

Tool: `close_docx_file`

When you finish with all operations, you must call `close_docx_file` in order to write your changes to disk.

If you don't close the file, all your changes will not be written to disk and lost.

### Gets the plain-text content

Tool: `get_plain_text_content`
Input params: `characterCountLimit` and `startingAfterParagraphId`

You can get the plain-text content of a docx file using the `get_plain_text_content` tool. It supports pagination where you can specify the `characterCountLimit` param (max: 20000) to limit the number of characters returned and the `startingAfterParagraphId` param to start after a specific paragraph. You should set the `characterCountLimit` to `20000`.

The response contains `content`, `lastParagraphId` (for using in the next subsequent `get_plain_text_content` calls), and `has_more` (indicating whether there is more content to be fetched).

`get_plain_text_content` is excellent when you want to review the content of the docx file without formatting.

Each paragraph is prepended with the paragraph ID that looks like `[id: PARAGRAPH_ID]`. You can use the `get_paragraph` tool to get the specific paragraph with its style before performing modifications. The paragraph may contain <ins> and <del> to indicate tracked insertions and deletions.

You must invoke `open_docx_file` before using `get_plain_text_content`.

### Gets the markup content

Tool: `get_markup_content`
Input params: `characterCountLimit` and `startingAfterParagraphId`

You can get the markup content of a docx file using the `get_markup_content` tool. It supports pagination where you can specify the `characterCountLimit` param (max: 20000) to limit the number of characters returned and the `startingAfterParagraphId` param to start after a specific paragraph. You should set the `characterCountLimit` to `20000`.

The response contains `content`, `lastParagraphId` (for using in the next subsequent `get_markup_content` calls), and `has_more` (indicating whether there is more content to be fetched).

`get_markup_content` returns the content in the markup language that includes styles. You should only use this tool if you want to understand the styles in order to make edits that follow the current styles of the doc.

You must invoke `open_docx_file` before using `get_markup_content`.

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
Input params: `paragraphId` (required), `commentedOverText` (required) and `commentText` (required)

For adding a comment, you must provide the following params:
1. `paragraphId`: the paragraph ID that you want to comment over.
2. `commentedOverText`: the plain-text text within the selected paragraph that you want to comment over.
3. `commentText`: the comment itself.

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

For `<bullet>`, you can only change its `id` and `level` attributes. The inner HTML of `<bullet>` is ignored and will be auto-generated.

Note that whitespaces and tabs within a `<span>` are significant.

One common error is that the original text content and the rewritten text content do not match. You must identify the differences and correct the rewritten paragraph to have its text content to match the original text content.

If you want to delete a paragraph, you should use the `delete_paragraph` tool instead of rewriting it with `<del>`.

Pay attention to HTML entities. For many symbols, we have to use their HTML entities e.g. `&#x201F;`. Do not convert HTML entities to other forms e.g. `\uXXXX`.

Try to preserve the styles of the paragraph and the spans involved.

### Inserts a paragraph

Tool: `insert_paragraph`
Input params: `newParagraphs` (required), `position` (optional)

For inserting one or more paragraphs, you will need to specify the following parameters:
1. `newParagraphs` (required): the new paragraphs. It must contain one or more top-level `<p>`s or `<gap />`s. A `<p>` must not contain the `id` attribute. If a paragraph starts with a bullet point, you must choose the appropriate `id` and `level` attribute for `<bullet>`; both attributes must not be `null`. The content of `<bullet>` will be automatically generated based on its `id` and `level` attribute.
2. `position`: the insertion position containing `paragraphId` and `beforeOrAfter`. `beforeOrAfter` must be either `before` or `after` to indicate whether the new paragraph should be inserted before or after the specified paragraph. If you want to insert the new paragraph at the end of the docx file, then you must specify `position` to `null`.

In the redline mode, you must not use `<ins>` or `<del>` when inserting a new paragraph because `<ins>` and `<del>` are automatically inserted. You must not set the `id` attribute of a new paragraph.

When inserting a paragraph, you must consider whether the new paragraph is a continuation of the previous paragraph. If the previous paragraph has `<bullet>` and the new paragraph is the continuation of the previous paragraph, you must consider using `<bullet>` with the same ID and level.

Pay attention to HTML entities. For many symbols, we have to use their HTML entities e.g. `&#x201F;`. Do not convert HTML entities to other forms e.g. `\uXXXX`.

Try to match the styles of the paragraph and the spans involved; we prefer them to match the styles of the nearby paragraphs. You must decide the appropriate styles of `<bullet>` by setting its `class` attribute if there is a bullet point.

You must decide how the gaps before, after, and between pargraphs should be implemented by adding `<gap />`s, setting `pt-[<number>px]`, and/or setting `pb-[<number>px]`. If you don't know how the gaps are implemented, you must use the `get_paragraph` tool to get a nearby/related paragraph to understand its gap implementation.

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

The result will also contain the surrounding `<gap />`s if exists. This helps indicate how the surrounding gaps of the paragraph are implemented.

### Reads a PDF file

Tool: `read_pdf`
Input params: `filePath` (required)

The `read_pdf` endpoint will read the PDF in the plain text format.

You must not write code to read PDF.

### Initializes

Tool: `initialize`
Input params: `confirmation` (required), `signature` (required), and `model`

You must call the `initialize` tool before using any other tool in the legalrabbit-docx MCP. You only need to call it once per session.

This is to ensure that you've loaded the legalrabbit-docx skill. In the past, sometimes you forgot to load the legalrabbit-docx skill.

The `confirmation` must be `The legalrabbit-docx skill has been loaded.`.

The `signature` must be `[SIGNATURE]`.

If you know which AI model is being used, please set the value of `model`. If you don't know, you can leave it as `null`. You must never set `model` to an empty string.

The tool might return the error stating the skill's and the agent's versions are not compatible with the legalrabbit-docx MCP. If this happens, you must re-read the legalrabbit-docx skill and the legalrabbit-docx-subagent subagent. Then, you can retry. If the error persists, you must stop and tell the user to restart Claude Cowork.
