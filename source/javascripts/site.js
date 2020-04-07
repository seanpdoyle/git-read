import "details-element-polyfill"
import "scroll-behavior-polyfill"

const scrollToCurrent = (scope) => {
  for (const current of scope.querySelectorAll('[aria-current="page"]')) {
    current.scrollIntoView({ inline: "center" })
  }
}

document.addEventListener("DOMContentLoaded", () => {
  scrollToCurrent(document)

  for (const detailsElement of document.querySelectorAll("details")) {
    detailsElement.addEventListener("toggle", () => {
      if (detailsElement.open) {
        scrollToCurrent(detailsElement)
      }
    })
  }
})
