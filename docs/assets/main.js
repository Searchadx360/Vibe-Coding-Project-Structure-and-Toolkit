(function () {
  "use strict";

  const { CATEGORIES, PROJECTS } = window.CLAUDE_INDEX || { CATEGORIES: [], PROJECTS: [] };

  function escapeHtml(str) {
    return str.replace(/[&<>"']/g, function (c) {
      return { "&": "&amp;", "<": "&lt;", ">": "&gt;", '"': "&quot;", "'": "&#39;" }[c];
    });
  }

  function cardHtml(project) {
    return (
      '<a class="card" href="' +
      escapeHtml(project.href) +
      '" target="_blank" rel="noopener">' +
      '<div class="card-title">' +
      escapeHtml(project.title) +
      "</div>" +
      '<div class="card-desc">' +
      escapeHtml(project.description) +
      "</div>" +
      '<div class="card-tags">' +
      project.tags.map(function (t) { return '<span class="tag">' + escapeHtml(t) + "</span>"; }).join("") +
      "</div>" +
      '<div class="card-link">open &rarr;</div>' +
      "</a>"
    );
  }

  function render(filterText) {
    const root = document.getElementById("catalog-root");
    if (!root) return;

    const query = (filterText || "").trim().toLowerCase();
    let totalShown = 0;
    let html = "";

    CATEGORIES.forEach(function (cat) {
      const items = PROJECTS.filter(function (p) {
        if (p.category !== cat.id) return false;
        if (!query) return true;
        const haystack = (p.title + " " + p.description + " " + p.tags.join(" ") + " " + cat.label)
          .toLowerCase();
        return haystack.indexOf(query) !== -1;
      });

      if (items.length === 0) return;
      totalShown += items.length;

      html +=
        '<section class="category-block">' +
        '<div class="category-head">' +
        '<span class="category-path"># ~/claude-projects/' +
        escapeHtml(cat.label) +
        "/</span>" +
        '<span class="category-tagline">' +
        escapeHtml(cat.tagline) +
        "</span>" +
        '<span class="category-count">' +
        items.length +
        (items.length === 1 ? " entry" : " entries") +
        "</span>" +
        "</div>" +
        '<div class="card-grid">' +
        items.map(cardHtml).join("") +
        "</div>" +
        "</section>";
    });

    if (totalShown === 0) {
      html = '<div class="empty-state">no matches for "' + escapeHtml(filterText) + '" — try a different keyword</div>';
    }

    root.innerHTML = html;

    const countEl = document.getElementById("search-count");
    if (countEl) {
      countEl.textContent = query ? totalShown + (totalShown === 1 ? " match" : " matches") : PROJECTS.length + " total";
    }
  }

  document.addEventListener("DOMContentLoaded", function () {
    render("");
    const input = document.getElementById("search-input");
    if (input) {
      input.addEventListener("input", function (e) {
        render(e.target.value);
      });
    }
  });
})();
