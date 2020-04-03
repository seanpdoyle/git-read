import Turbolinks from "turbolinks"

Turbolinks.start()

document.addEventListener("turbolinks:load", () => {
  for (const current of document.querySelectorAll('[aria-current="page"]')) {
    current.scrollIntoView({ block: "center", inline: "center" })
  }
})
