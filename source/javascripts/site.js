import "details-element-polyfill"
import "scroll-behavior-polyfill"
import Turbolinks from "turbolinks"

Turbolinks.start()

const scrollToCurrent = (scope) => {
  for (const current of scope.querySelectorAll('[aria-current="page"]')) {
    current.scrollIntoView({ inline: "center" })
  }
}

document.addEventListener("turbolinks:load", () => {
  scrollToCurrent(document)

  for (const detailsElement of document.querySelectorAll("details")) {
    detailsElement.addEventListener("toggle", () => {
      if (detailsElement.open) {
        scrollToCurrent(detailsElement)
      }
    })
  }
})
