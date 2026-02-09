window.addEventListener('scroll', () => {
  const nav = document.querySelector('nav');
  if (window.scrollY > 50) {
    nav.classList.add('shadow');
  } else {
    nav.classList.remove('shadow');
  }
});
 