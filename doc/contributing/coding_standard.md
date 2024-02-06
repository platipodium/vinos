<!--
SPDX-FileContributor: Carsten Lemmen <carsten.lemmen@hereon.de>
SPDX-FileCopyrightText: 2023-2024 Helmholtz-Zentrum hereon GmbH
SPDX-License-Identifier: CC0-1.0
-->

# Coding standard

We hope you find it easy to read our code and understand its structure. When you contribute code to our project, we ask you to adhere to coding standards, the most important one is consistency with the current code.

## Coding rules

1. Consistency
   : Whatever you do, be consistent in what you do. This is the guiding principle all other rules are subjected to

2. Line break
   : NetLogo code does not need line breaks, but humans do. Do use line breaks to separate statements.

3. Empty lines.
   : Do not overuse empty lines, but reserve them for separating logical units or blocks of statements, just like
   you would use paragraphs in a text. Separate procedures with one empty line.

4. White space
   : Do use white space around square brackets `[' `]', but not around parentheses `(' `)'. Avoid space at the end
   of a line.

5. Indentation
   Use consistent and logical indentation to make the code more readable. Each level of indentation should consist of two spaces.

6. Blocks
   Start a block with `[` at the end of the preceding line, intent the contents of the block, and end the block with a `]' at the original indentation level. You can keep the complete block on a single line if the block is not too long. Valid examples are

```
  ifelse true [ print "yes" ][ print "no" ]
  if (count turtles > count patches) [
    print "There are more turtles than patches
  ]
  ask patches [
    carefully [
        let a count turtles / count patches
    ][
        print "Cannot divided by zero patches"
    ]
  ]
```

7. Naming conventions
   : Use meaningful english names for variables, procedures, and functions. Names should be descriptive and use lowercase letters with a hyphen between words. For functions and procedures, choose a verb, possibly followed by an object, or prefixed by the agent that this procedure applies to.

8. Comments:
   : Use comments to explain complex sections of code, as well as to provide an overview of what the code does. Use the NetLogo comment syntax, which is a semicolon (`;').

9. Error handling:
   Always include error handling code to catch and handle unexpected exceptions. Preferably either halt the simulation with `stop` or `error`, or pass `nobody` as a return value to indicate and exception. Use appropriate error messages to help users diagnose and fix problems.

10. Documentation:
    Provide documentation for the code, including a description of its purpose, its input and output parameters, and examples of its usage.
