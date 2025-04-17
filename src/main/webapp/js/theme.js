(function() {
    const KEY = 'theme';
    const DARK = 'dark';
    function getTheme() {
        return localStorage.getItem(KEY) || 'light';
    }
    function apply(theme) {
        document.body.classList.toggle(DARK, theme === DARK);
    }
    window.toggleTheme = () => {
        const next = getTheme() === DARK ? 'light' : DARK;
        localStorage.setItem(KEY, next);
        apply(next);
    };
    document.addEventListener('DOMContentLoaded', () => {
        apply(getTheme());
    });
})();
