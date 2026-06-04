LegalRabbit DOCX Claude plugin
===============================

A Claude Cowork plugin that creates and modifies DOCX files locally. You will save tons of time when your Cowork can manipulate docx files directly. This plugin uses 2-5x fewer tokens than the Anthropic's docx skill.

You can use our DOCX plugin together with [Claude for Legal](https://github.com/anthropics/claude-for-legal) to enable a more seamless experience of working with a docx file!

[![Demo](https://github.com/user-attachments/assets/cc89cf6b-2d9d-4134-a399-523e72489ce4)](https://drive.google.com/file/d/1UNlUJYwkNX3NiANDkLLb3UoRSms2dXCU/view?usp=drive_link)

[Click to see the demo](https://drive.google.com/file/d/1UNlUJYwkNX3NiANDkLLb3UoRSms2dXCU/view?usp=drive_link)


Capabilities:
- Read the content and the comments.
- Create a new docx file. Optionally, you can use an existing docx file as the template. The styles will be copied from the template.
- Add tracked changes to an existing docx file.
- Add comments and reply to comments.

We've developed the DOCX engine from the ground up to work well with LLM. Our engine consumes much fewer tokens, faster, and more reliable than the current alternatives.
 
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

1. Go to [the 1.0.0 release page](https://github.com/LegalRabbit-AI/legalrabbit-docx-claude-plugin/releases/tag/1.0.0).
2. Download `legalrabbit-docx-claude-plugin.zip`. DO NOT download `Source code (zip)`.
3. Open your Cowork and go to `Customize`
4. Click on the `+` on the right side of `Personal Plugins`.
5. Choose `+ Create Plugin >` and `Upload Plugin`
6. Upload the downloaded `Source code (zip)` and click `Upload`
7. There will be a warning about our local MCP server named `docx`. Please click `Continue`.

Now you can test it using the example prompt above.


Support
---------

Contact: tanin(at)legalrabbit.ai

Learn more about us: [LegalRabbit](https://legalrabbit.ai/)


Release a new version
----------------------

1. Go to [the release Github Actions workflow](https://github.com/LegalRabbit-AI/legalrabbit-docx-claude-plugin/actions/workflows/release.yml).
2. Click `Run workflow` and fills in an appropriate tag e.g. `0.7.0`, `0.7.0-rc1`, `0.7.0-dev`
3. Wait for the workflow to complete.
4. A new release will be created as a pre-release draft.
5. Go to the [releases page](https://github.com/LegalRabbit-AI/legalrabbit-docx-claude-plugin/releases) and edit the new release accordingly.
6. Publish the release.
