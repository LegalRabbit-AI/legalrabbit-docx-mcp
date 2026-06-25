DOCX MCP for Claude Cowork and Codex
====================================================================

legalrabbit-docx-mcp enables your Claude Cowork and Codex to read and manipulate DOCX files locally. 

Our MCP uses 2-5x fewer tokens than the Anthropic's docx skill, is faster, and is more reliable. There are 2 reasons why:

1. Our MCP supports a bidirectional transformation of HTML <-> DOCX. AI will write HTML. [AI is excellent and efficient at processing HTML](https://claude.com/blog/using-claude-code-the-unreasonable-effectiveness-of-html).
2. Our MCP supports "surgical editing". AI can specify which paragraph/table/row to edit without editing the entire doc.

You can use our DOCX plugin together with [Claude for Legal](https://github.com/anthropics/claude-for-legal) to enable a more seamless experience of working with a docx file!

[Click to see the demo](https://drive.google.com/file/d/1UNlUJYwkNX3NiANDkLLb3UoRSms2dXCU/view?usp=drive_link)

[![Demo](https://github.com/user-attachments/assets/cc89cf6b-2d9d-4134-a399-523e72489ce4)](https://drive.google.com/file/d/1UNlUJYwkNX3NiANDkLLb3UoRSms2dXCU/view?usp=drive_link)

Capabilities:
- Read the content and the comments.
- Create a new docx file. Optionally, you can use an existing docx file as the template. The styles will be copied from the template.
- Add tracked changes to an existing docx file.
- Add comments and reply to comments.
 
We are using this plugin at [LegalRabbit](https://legalrabbit.ai) to speed up our legal services. Try it out and let us know if you have any questions.

The plugin works offline, ensuring data privacy and security of your DOCX files.

Example prompts
----------------

- _Create a NDA docx file based on NDA-template.docx. My company is LegalRabbit. The other party is John Austin._
- _Review and flag issues in 'Data Processing Agreement.docx'. You can redline and add comments on the doc directly._
- _I've made comments in 'BPO referral agreement.docx'. Please address them._
- _Delete all comments and provide customer-facing comments_ 

How to install
---------------

![Claude Installation](https://raw.githubusercontent.com/LegalRabbit-AI/legalrabbit-media/main/claude.jpg) __For Claude Cowork:__

1. Go to the latest release, 1.0.0, and download [legalrabbit-docx.mcpb](https://github.com/LegalRabbit-AI/legalrabbit-docx-mcp/releases/download/1.0.0/legalrabbit-docx.mcpb).
2. Switch to Claude and go to `Settings`
3. Select the `Extensions` tab and click on `Advanced settings`
4. Click `Install Extension` and select the downloaded `legalrabbit-docx.mcpb` file.
5. Click `Install`
6. Add `You must use the legalrabbit-docx-mcp tool for reading and manipulating docx files` to `CLAUDE.md`

![Claude Installation](https://raw.githubusercontent.com/LegalRabbit-AI/legalrabbit-media/main/openai.jpg) __For Codex:__

1. Go to `Plugins` and click the `+ v` (the down arrow next to the plug button) on the top right corner
2. Select `+ Add marketplace`
3. Fill `Source` with `https://github.com/LegalRabbit-AI/legalrabbit-docx-mcp` and click `Add marketplace`
4. On the Plugins page, click on the `legalrabbit-tools` marketplace.
5. Click `Add plugin` on the Legalrabbit Docx plugin.
6. Add `You must use the legalrabbit-docx skill for reading and manipulating docx files` to `AGENTS.md`

🛠️ __Testing__

You can try `Create a beautifully written short docx`


Support
---------

Contact: tanin(at)legalrabbit.ai

Learn more about us: [LegalRabbit](https://legalrabbit.ai/)


Release a new version
----------------------

1. Go to [the release Github Actions workflow](https://github.com/LegalRabbit-AI/legalrabbit-docx-mcp/actions/workflows/release.yml).
2. Click `Run workflow` and fills in an appropriate tag e.g. `1.0.0`, `1.0.0-dev`
3. Wait for the workflow to complete.
4. Go to the [releases page](https://github.com/LegalRabbit-AI/legalrabbit-docx-mcp/releases) and edit the new release accordingly.
