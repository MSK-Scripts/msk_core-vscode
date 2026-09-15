/**
 * Runs through the "vscode:uninstall" hook after the extension has been
 * uninstalled and VS Code was restarted. There is no vscode API here, so the
 * settings.json files are edited directly.
 *
 * Only string entries inside Lua.workspace.library that contain the extension
 * ID are removed, i.e. the library paths added by extension.js. The file is
 * not rewritten as JSON, so comments and formatting are preserved.
 */
const fs = require('fs');
const os = require('os');
const path = require('path');

const EXTENSION_ID = 'musiker15.msk-core-lua';
const PRODUCTS = ['Code', 'Code - Insiders', 'VSCodium', 'Cursor', 'Windsurf'];

function userDataRoots() {
    const home = os.homedir();
    const roots = [];

    if (process.env.VSCODE_PORTABLE) {
        roots.push(path.join(process.env.VSCODE_PORTABLE, 'user-data'));
    }

    for (const product of PRODUCTS) {
        if (process.platform === 'win32') {
            const appData =
                process.env.APPDATA || path.join(home, 'AppData', 'Roaming');
            roots.push(path.join(appData, product));
        } else if (process.platform === 'darwin') {
            roots.push(
                path.join(home, 'Library', 'Application Support', product)
            );
        } else {
            const config =
                process.env.XDG_CONFIG_HOME || path.join(home, '.config');
            roots.push(path.join(config, product));
        }
    }
    return roots;
}

/** settings.json of the default profile and of every additional profile. */
function settingsFiles(root) {
    const user = path.join(root, 'User');
    const files = [path.join(user, 'settings.json')];
    const profiles = path.join(user, 'profiles');
    try {
        for (const entry of fs.readdirSync(profiles, { withFileTypes: true })) {
            if (entry.isDirectory()) {
                files.push(path.join(profiles, entry.name, 'settings.json'));
            }
        }
    } catch {
        // No profiles.
    }
    return files;
}

// The Lua.workspace.library array and every single JSON string inside it.
// Only this array is touched, all other settings stay as they are.
const LIBRARY = /("Lua\.workspace\.library"\s*:\s*\[)([^\]]*)(\])/g;
const STRING = /\s*"(?:[^"\\\n]|\\.)*"\s*,?/g;

// A leftover comma before "]" is allowed in settings.json (JSONC).
function removeEntries(content) {
    return content.replace(LIBRARY, (match, open, items, close) => {
        const kept = items.replace(STRING, (entry) =>
            entry.includes(EXTENSION_ID) ? '' : entry
        );
        return open + kept + close;
    });
}

function clean(file) {
    let content;
    try {
        content = fs.readFileSync(file, 'utf8');
    } catch {
        return;
    }
    if (!content.includes(EXTENSION_ID)) return;

    const updated = removeEntries(content);
    if (updated !== content) fs.writeFileSync(file, updated, 'utf8');
}

if (require.main === module) {
    for (const root of userDataRoots()) {
        for (const file of settingsFiles(root)) clean(file);
    }
}

module.exports = { removeEntries };
