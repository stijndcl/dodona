import jQuery from "jquery";

// jQuery aliases
window.jQuery = jQuery;
window.jquery = jQuery;
window.$ = jQuery;

import "polyfills.js";
import { initTooltips } from "util.js";
import { initClipboard } from "copy";

// Use a global dodona object to prevent polluting the global na
const dodona = window.dodona || {};
dodona.initTooltips = initTooltips;
window.dodona = dodona;

// Initialize clipboard.js
initClipboard();

$(initTooltips);
