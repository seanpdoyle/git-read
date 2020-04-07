import "../stylesheets/site.css"

import "details-element-polyfill"
import "scroll-behavior-polyfill"
import Turbolinks from "turbolinks"

Turbolinks.start()

addEventListener("turbolinks:load", () => {
  for (let current of document.querySelectorAll('[aria-current="page"]')) {
    current.removeAttribute("aria-current")
  }

  for (const link of document.querySelectorAll("a")) {
    if (link.href === window.location.href) {
      link.setAttribute("aria-current", "page")
      link.scrollIntoView({ block: "center", scroll: "smooth" })
    }
  }
})
