. 'C:\vscode\CreateUser.ps1'
Add-Type -AssemblyName System.Windows.Forms
$btn_Click = {
	FuncMessageOut -message $txtmessage.Text 
}
. $MyInvocation.InvocationName.Replace('form.ps1', 'form.designer.ps1')
$Form1.ShowDialog()
