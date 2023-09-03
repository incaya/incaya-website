window.addEventListener("load", function () {
  const path = window.location.href;
  if (path.includes("la-cooperative")) {
    document.getElementById("main-nav-scop").classList.add("active");
  } else if (path.includes("nos-references")) {
    document.getElementById("main-nav-ref").classList.add("active");
  } else if (path.includes("blog")) {
    document.getElementById("main-nav-blog").classList.add("active");
  } else {
    document.getElementById("main-nav-home").classList.add("active");
  }
});
