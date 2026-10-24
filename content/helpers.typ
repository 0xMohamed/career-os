// content/helpers.typ
//
// Shared composition helpers for Career OS.
// Allows application variants to select, filter, and format
// achievements and experience highlights without duplicating text.

/// Extracts the display string from a bullet item (whether it is a string or structured dictionary)
#let format-bullet(item) = {
  if type(item) == dictionary and "statement" in item {
    item.statement
  } else {
    item
  }
}

/// Selects and limits project achievements based on explicit IDs, tags, or count.
/// Fails with an actionable assertion if an explicitly requested ID does not exist,
/// preventing silent omissions or stale references.
#let select-achievements(proj, tags: none, ids: none, limit: none) = {
  let filtered = if ids != none {
    let available-ids = proj.achievements.map(ach => if type(ach) == dictionary and "id" in ach { ach.id } else { none })
    assert(
      ids.dedup().len() == ids.len(),
      message: "select-achievements: Duplicate achievement IDs requested in project '" + proj.title + "': " + repr(ids),
    )
    for req-id in ids {
      assert(
        req-id in available-ids,
        message: "select-achievements: Requested ID '" + req-id + "' not found in project '" + proj.title + "'. Available IDs: " + repr(available-ids),
      )
    }
    ids.map(req-id => proj.achievements.find(ach => type(ach) == dictionary and "id" in ach and ach.id == req-id))
  } else if tags != none {
    let matches = proj.achievements.filter(ach => {
      if type(ach) == dictionary and "tags" in ach {
        ach.tags.any(t => t in tags)
      } else {
        false
      }
    })
    assert(
      matches.len() > 0,
      message: "select-achievements: Tag filter " + repr(tags) + " matched 0 achievements in project '" + proj.title + "'",
    )
    matches
  } else {
    proj.achievements
  }

  let count = if limit != none {
    calc.min(limit, filtered.len())
  } else {
    filtered.len()
  }

  (
    ..proj,
    achievements: filtered.slice(0, count),
    limit: count,
  )
}

/// Selects and limits experience highlights based on explicit IDs, tags, or count, with optional role/summary framing.
/// Fails with an actionable assertion if an explicitly requested ID does not exist,
/// preventing silent omissions or stale references.
#let select-experience(entry, tags: none, ids: none, limit: none, role: none, summary: none) = {
  let filtered = if ids != none {
    let available-ids = entry.highlights.map(hl => if type(hl) == dictionary and "id" in hl { hl.id } else { none })
    assert(
      ids.dedup().len() == ids.len(),
      message: "select-experience: Duplicate highlight IDs requested in company '" + entry.company + "': " + repr(ids),
    )
    for req-id in ids {
      assert(
        req-id in available-ids,
        message: "select-experience: Requested ID '" + req-id + "' not found in company '" + entry.company + "'. Available IDs: " + repr(available-ids),
      )
    }
    ids.map(req-id => entry.highlights.find(hl => type(hl) == dictionary and "id" in hl and hl.id == req-id))
  } else if tags != none {
    let matches = entry.highlights.filter(hl => {
      if type(hl) == dictionary and "tags" in hl {
        hl.tags.any(t => t in tags)
      } else {
        false
      }
    })
    assert(
      matches.len() > 0,
      message: "select-experience: Tag filter " + repr(tags) + " matched 0 highlights in company '" + entry.company + "'",
    )
    matches
  } else {
    entry.highlights
  }

  let count = if limit != none {
    calc.min(limit, filtered.len())
  } else {
    filtered.len()
  }

  (
    ..entry,
    role: if role != none { role } else { entry.role },
    summary: if summary != none { summary } else { entry.summary },
    highlights: filtered.slice(0, count),
  )
}
