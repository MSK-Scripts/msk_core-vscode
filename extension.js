const vscode = require('vscode');
const path = require('path');

const EXTENSION_ID = 'musiker15.msk-core-lua';
const LIBRARY_DIR = 'library';
const RUNTIME = 'Lua 5.4';

/**
 * The definitions are deliberately referenced DIRECTLY from the extension
 * folder. cfxlua-vscode moves them to globalStorage instead, and that breaks
 * as soon as globalStorage gets cleared: the source has already been moved,
 * the settings point to nothing and a restart does not fix it.
 */
function libraryPath(context) {
    return path.join(context.extensionPath, LIBRARY_DIR);
}

/** User settings, so the definitions apply globally in every project. */
function luaConfig() {
    return vscode.workspace.getConfiguration('Lua');
}

function mskSetting(key, fallback) {
    return vscode.workspace.getConfiguration('mskCore').get(key, fallback);
}

/**
 * Adds the library path and removes entries left by earlier versions of this
 * extension (the folder name contains the version, so an update would
 * otherwise leave dead paths behind).
 */
async function setLibrary(context, enable) {
    const config = luaConfig();
    const target = libraryPath(context);
    const current = config.get('workspace.library') || [];

    const cleaned = current.filter((entry) => {
        if (typeof entry !== 'string') return true;
        return !entry.includes(EXTENSION_ID) && entry !== target;
    });

    if (enable) cleaned.push(target);

    const unchanged =
        cleaned.length === current.length &&
        cleaned.every((value, index) => value === current[index]);
    if (unchanged) return target;

    await config.update(
        'workspace.library',
        cleaned,
        vscode.ConfigurationTarget.Global
    );
    return target;
}

/**
 * msk_core requires lua54 'yes'. The runtime is only set for the workspace,
 * and only if it contains a fxmanifest.lua. Other Lua projects (LuaJIT, 5.1,
 * Neovim configs) stay untouched, and a runtime that is already set
 * explicitly in the workspace is never overwritten.
 */
async function ensureRuntime() {
    if (!mskSetting('setRuntime', true)) return;
    if (!vscode.workspace.workspaceFolders?.length) return;

    const inspected = luaConfig().inspect('runtime.version');
    if (inspected?.workspaceValue !== undefined) return;
    if (inspected?.globalValue === RUNTIME) return;

    const manifests = await vscode.workspace.findFiles(
        '**/fxmanifest.lua',
        '**/node_modules/**',
        1
    );
    if (manifests.length === 0) return;

    await luaConfig().update(
        'runtime.version',
        RUNTIME,
        vscode.ConfigurationTarget.Workspace
    );
}

async function activate(context) {
    await setLibrary(context, mskSetting('enableLibrary', true));
    await ensureRuntime();

    context.subscriptions.push(
        vscode.commands.registerCommand('mskCore.reload', async () => {
            const active = mskSetting('enableLibrary', true);
            const target = await setLibrary(context, active);
            vscode.window.showInformationMessage(
                active
                    ? `MSK Core: definitions added (${target})`
                    : 'MSK Core: definitions removed.'
            );
        }),
        vscode.commands.registerCommand('mskCore.showLibraryPath', () => {
            vscode.window.showInformationMessage(libraryPath(context));
        }),
        vscode.workspace.onDidChangeConfiguration(async (event) => {
            if (event.affectsConfiguration('mskCore.enableLibrary')) {
                await setLibrary(context, mskSetting('enableLibrary', true));
            }
            if (event.affectsConfiguration('mskCore.setRuntime')) {
                await ensureRuntime();
            }
        }),
        vscode.workspace.onDidChangeWorkspaceFolders(() => ensureRuntime())
    );
}

/**
 * Intentionally empty. deactivate() runs on EVERY VS Code shutdown, not only
 * on uninstall. Removing the entry here would mean writing it again on every
 * start, and with Settings Sync that change bounces across all machines.
 * Cleanup happens in uninstall.js instead (hook "vscode:uninstall").
 */
function deactivate() {}

module.exports = { activate, deactivate };
