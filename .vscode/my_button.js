exports.execute = async (args) => {
    // args => https://egodigital.github.io/vscode-powertools/api/interfaces/_contracts_.buttonactionscriptarguments.html

    // s. https://code.visualstudio.com/api/references/vscode-api
    const vscode = args.require('vscode');
    //////import * as vscode from 'vscode';
    // vscode.Powershell.showWinFormDesigner()
    // Powershell.showWinFormDesigner()
    // workbench.action.Powershell.showWinFormDesigner
    // vscode.showWinFormDesigner

    vscode.commands.executecommand('command.showWinFormDesigner')
    // vscode.commands.executeCommand('vscode.Powershell.showWinFormDesigner')
    // vscode.commands.executeCommand('Powershell.showWinFormDesigner')
    // vscode.commands.executeCommand('workbench.action.Powershell.showWinFormDesigner')
};