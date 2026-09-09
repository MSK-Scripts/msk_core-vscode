const vscode = require('vscode');
const path = require('path');

const EXTENSION_ID = 'musiker15.msk-core-lua';
const LIBRARY_DIR = 'library';

/**
 * Die Definitionen werden bewusst DIREKT aus dem Extension-Ordner referenziert.
 * cfxlua-vscode verschiebt sie stattdessen nach globalStorage, und genau daran
 * geht es kaputt, sobald globalStorage geleert wird: die Quelle ist dann schon
 * verschoben, die Settings zeigen ins Leere und ein Neustart repariert nichts.
 */
function libraryPath(context) {
    return path.join(context.extensionPath, LIBRARY_DIR);
}

/** User-Settings, damit die Definitionen global in jedem Projekt greifen. */
function luaConfig() {
    return vscode.workspace.getConfiguration('Lua');
}

/**
 * Trägt den Library-Pfad ein und räumt dabei Einträge früherer Versionen
 * dieser Extension weg (der Ordnername enthält die Version, ein Update
 * hinterlässt sonst tote Pfade).
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
 * msk_core setzt lua54 'yes' voraus. Die Runtime-Version wird nur angehoben,
 * nie heruntergesetzt, damit eine bestehende Konfiguration nichts verliert.
 */
async function ensureRuntime() {
    const config = luaConfig();
    if (config.get('runtime.version') !== 'Lua 5.4') {
        await config.update(
            'runtime.version',
            'Lua 5.4',
            vscode.ConfigurationTarget.Global
        );
    }
}

async function activate(context) {
    const enabled = vscode.workspace
        .getConfiguration('mskCore')
        .get('enableLibrary', true);

    await ensureRuntime();
    await setLibrary(context, enabled);

    context.subscriptions.push(
        vscode.commands.registerCommand('mskCore.reload', async () => {
            const active = vscode.workspace
                .getConfiguration('mskCore')
                .get('enableLibrary', true);
            const target = await setLibrary(context, active);
            vscode.window.showInformationMessage(
                active
                    ? `MSK Core: Definitionen eingebunden (${target})`
                    : 'MSK Core: Definitionen ausgehängt.'
            );
        }),
        vscode.commands.registerCommand('mskCore.showLibraryPath', () => {
            vscode.window.showInformationMessage(libraryPath(context));
        }),
        vscode.workspace.onDidChangeConfiguration(async (event) => {
            if (!event.affectsConfiguration('mskCore.enableLibrary')) return;
            const active = vscode.workspace
                .getConfiguration('mskCore')
                .get('enableLibrary', true);
            await setLibrary(context, active);
        })
    );
}

/**
 * Beim Deaktivieren wird der Eintrag entfernt, sonst bleibt nach einer
 * Deinstallation ein toter Pfad in den User-Settings stehen.
 */
async function deactivate() {
    const config = luaConfig();
    const current = config.get('workspace.library') || [];
    const cleaned = current.filter(
        (entry) => typeof entry !== 'string' || !entry.includes(EXTENSION_ID)
    );
    if (cleaned.length === current.length) return;
    await config.update(
        'workspace.library',
        cleaned,
        vscode.ConfigurationTarget.Global
    );
}

module.exports = { activate, deactivate };
