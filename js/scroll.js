const backToTopButton = document.getElementById('to-top');
backToTopButton.style.display = 'none';
window.addEventListener('scroll', () => {
  if (window.pageYOffset > 0) {
    backToTopButton.style.display = 'block';
  } else {
    backToTopButton.style.display = 'none';
  }
});
