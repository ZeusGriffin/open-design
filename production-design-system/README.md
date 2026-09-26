# Base Production Design System

A reusable **video/reference -> inventory -> exact build -> verification -> deck/PDF -> repository** workflow.

## Rule

When a project is not already pre-made, do not jump directly to a final build. First create an evidence-backed production inventory, then define the structure, then build only from verified inputs.

## Standard production pass

1. Capture source references and preserve the original links.
2. Inventory every visible/confirmed output, software tool, hardware component, fabricated part, interface, and dependency.
3. Mark each line **CONFIRMED**, **LIKELY/REFERENCE**, or **UNKNOWN**. Never promote an inference to a fact.
4. Build a picture list for every inventory item.
5. Convert the inventory into a system architecture and exact folder structure.
6. Create the BOM and end-to-end build only after the reference is sufficiently verified.
7. Add verification checks for the real target environment.
8. Package the work as source files + README + visual deck/PDF + build notes.
9. Preserve the approved baseline; future revisions are change-only.

## Repository layout

```text
production-design-system/
  README.md
  templates/
    production-template.md
  tests/
    test-001-video-reference/
      README.md
      sources.md
      inventory/
        video-01.md
        video-02.md
        software-hardware-matrix.md
      visual-reference/
        picture-list.md
```

Test 001 uses two YouTube Shorts supplied by Zee as the first reference set.
