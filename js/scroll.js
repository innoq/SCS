/** jump back to top button */
const toTopButton = document.getElementById('to-top');
toTopButton.style.display = 'none';

function toggleToTopButton() {
  if (window.pageYOffset > 0) {
    toTopButton.style.display = 'block';
  } else {
    toTopButton.style.display = 'none';
  }
}

/** jump to next section button */
const sections = document.querySelectorAll('section');
const jumpToNextSectionButton = document.getElementById('jump-to-next-section');
updateJumpToNextSectionButtonTarget();

function updateJumpToNextSectionButtonTarget() {
    const windowHeight = window.innerHeight;
    const scrollPosition = window.scrollY + windowHeight;

    for (const section of sections) {
        if (section.offsetTop > scrollPosition && section.id) {
            jumpToNextSectionButton.href = `#${section.id}`;
            jumpToNextSectionButton.style.display = 'block';
            return;
        }
    }
    jumpToNextSectionButton.style.display = 'none';
}

/** update the buttons when scrolling */
window.addEventListener('scroll', () => {
  toggleToTopButton();
  updateJumpToNextSectionButtonTarget();
});

