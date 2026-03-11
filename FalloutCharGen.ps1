Add-Type -AssemblyName System.Windows.Forms
Add-Type -AssemblyName System.Drawing

$S = @("Strength","Perception","Endurance","Charisma")
$S += @("Intelligence","Agility","Luck")

$SK = @("SG","BG","EW","Unarmed","Speech","Barter","Gambling")
$SK += @("Outdoorsman","Sneak","Steal","Lockpick","Traps")
$SK += @("FA","Doctor","Science","Repair")

$SN = @("Small Guns","Big Guns","Energy Weapons","Unarmed")
$SN += @("Speech","Barter","Gambling","Outdoorsman")
$SN += @("Sneak","Steal","Lockpick","Traps")
$SN += @("First Aid","Doctor","Science","Repair")

$TK = @("FA","BloodyMess","Bruiser","Jinxed","SF","GN")
$TK += @("OH","ChemReliant","Finesse","CoP","Kamikaze")
$TK += @("NP","HH","Skilled","FastShot","Gifted")

$TN = @("Fast Metabolism","Bloody Mess","Bruiser","Jinxed")
$TN += @("Small Frame","Good Natured","One Hander","Chem Reliant")
$TN += @("Finesse","Chem Resistant","Kamikaze","Night Person")
$TN += @("Heavy Handed","Skilled","Fast Shot","Gifted")

$P = New-Object System.Collections.Generic.List[int]
foreach ($v in @(1,3,4,6,7,8,9)) {
    for ($x=0;$x -lt 10;$x++) { $P.Add($v) }
}
for ($x=0;$x -lt 12;$x++) { $P.Add(2) }
for ($x=0;$x -lt 5;$x++)  { $P.Add(5) }
for ($x=0;$x -lt 3;$x++)  { $P.Add(10) }
$PA = $P.ToArray()

function GW {
    $idx = Get-Random -Minimum 0 -Maximum $PA.Count
    return $PA[$idx]
}

function New-Char {
    param([bool]$Br,[bool]$FS,[bool]$Gi)
    do {
        $b = @(0,0,0,0,0,0,0)
        for ($i=0;$i -lt 6;$i++) { $b[$i] = GW }
        $L = 40-($b[0]+$b[1]+$b[2]+$b[3]+$b[4]+$b[5])
    } while ($L -lt 1 -or $L -gt 10)
    $b[6] = $L
    if ($Br) { $b[0]=[Math]::Min(10,$b[0]+2) }
    if ($FS) { $b[5]=[Math]::Min(10,$b[5]+1) }
    for ($i=6;$i -gt 0;$i--) {
        $j = Get-Random -Minimum 0 -Maximum ($i+1)
        $t=$b[$i];$b[$i]=$b[$j];$b[$j]=$t
    }
    if ($Gi) {
        for ($i=0;$i -lt 7;$i++) {
            $b[$i]=[Math]::Min(10,$b[$i]+1)
        }
    }
    return $b
}

function Roll {
    $ti = Get-Random -InputObject (0..15) -Count 2
    $tk = $ti | ForEach-Object { $TK[$_] }
    $tn = $ti | ForEach-Object { $TN[$_] }
    $hB = [bool]($tk -contains "Bruiser")
    $hF = [bool]($tk -contains "FastShot")
    $hG = [bool]($tk -contains "Gifted")
    $st = New-Char -Br $hB -FS $hF -Gi $hG
    $si = Get-Random -InputObject (0..15) -Count 3
    $sk = $si | ForEach-Object { $SK[$_] }
    $sn = $si | ForEach-Object { $SN[$_] }
    return @{
        st=$st; tk=$tk; tn=$tn
        sk=$sk; sn=$sn
        hB=$hB; hF=$hF; hG=$hG
    }
}

$form = New-Object System.Windows.Forms.Form
$form.Text = "Vault-Tec Character Generator"
$form.Size = New-Object System.Drawing.Size(520,660)
$form.BackColor = [System.Drawing.Color]::FromArgb(10,15,10)
$form.StartPosition = "CenterScreen"
$form.FormBorderStyle = "FixedSingle"
$form.MaximizeBox = $false
$form.Add_FormClosing({
    param($s,$e)
    $e.Cancel = $false
})

$fntBig = New-Object System.Drawing.Font("Courier New",20)
$fntBig = New-Object System.Drawing.Font(
    "Courier New",20,
    [System.Drawing.FontStyle]::Bold)
$fntMed = New-Object System.Drawing.Font("Courier New",10)
$fntSml = New-Object System.Drawing.Font("Courier New",7)
$fntBtn = New-Object System.Drawing.Font("Courier New",9)

$cGreen  = [System.Drawing.Color]::FromArgb(180,240,0)
$cDkGrn  = [System.Drawing.Color]::FromArgb(60,120,40)
$cBg     = [System.Drawing.Color]::FromArgb(5,10,5)
$cCyan   = [System.Drawing.Color]::FromArgb(0,200,220)
$cLtGrn  = [System.Drawing.Color]::FromArgb(100,200,50)
$cYellow = [System.Drawing.Color]::FromArgb(255,200,0)
$cPurple = [System.Drawing.Color]::FromArgb(220,100,255)
$cMint   = [System.Drawing.Color]::FromArgb(0,255,150)
$cFade   = [System.Drawing.Color]::FromArgb(40,120,40)

$lbl = New-Object System.Windows.Forms.Label
$lbl.Text = "S.P.E.C.I.A.L."
$lbl.Font = $fntBig
$lbl.ForeColor = $cGreen
$lbl.Size = New-Object System.Drawing.Size(500,42)
$lbl.Location = New-Object System.Drawing.Point(10,10)
$lbl.TextAlign = "MiddleCenter"
$form.Controls.Add($lbl)

$sub = New-Object System.Windows.Forms.Label
$sub.Text = "VAULT-TEC CHARACTER GENERATOR"
$sub.Font = $fntSml
$sub.ForeColor = $cDkGrn
$sub.Size = New-Object System.Drawing.Size(500,16)
$sub.Location = New-Object System.Drawing.Point(10,52)
$sub.TextAlign = "MiddleCenter"
$form.Controls.Add($sub)

$rtb = New-Object System.Windows.Forms.RichTextBox
$rtb.Size = New-Object System.Drawing.Size(480,480)
$rtb.Location = New-Object System.Drawing.Point(15,72)
$rtb.BackColor = $cBg
$rtb.ForeColor = $cCyan
$rtb.Font = $fntMed
$rtb.ReadOnly = $true
$rtb.BorderStyle = "None"
$rtb.ScrollBars = "Vertical"
$form.Controls.Add($rtb)

$btnR = New-Object System.Windows.Forms.Button
$btnR.Text = "ROLL CHARACTER"
$btnR.Size = New-Object System.Drawing.Size(210,38)
$btnR.Location = New-Object System.Drawing.Point(15,572)
$btnR.BackColor = [System.Drawing.Color]::FromArgb(20,60,0)
$btnR.ForeColor = [System.Drawing.Color]::FromArgb(180,255,0)
$btnR.FlatStyle = "Flat"
$btnR.Font = $fntBtn
$form.Controls.Add($btnR)

$btnX = New-Object System.Windows.Forms.Button
$btnX.Text = "EXIT"
$btnX.Size = New-Object System.Drawing.Size(90,38)
$btnX.Location = New-Object System.Drawing.Point(400,572)
$btnX.BackColor = [System.Drawing.Color]::FromArgb(60,10,10)
$btnX.ForeColor = [System.Drawing.Color]::FromArgb(255,80,80)
$btnX.FlatStyle = "Flat"
$btnX.Font = $fntBtn
$btnX.Add_Click({ $form.Close() })
$form.Controls.Add($btnX)

function Show {
    $c = Roll
    $rtb.Clear()

    $rtb.SelectionColor = $cLtGrn
    $rtb.AppendText("  S.P.E.C.I.A.L.`n")
    $rtb.AppendText("  ----------------------------`n")
    for ($i=0;$i -lt 7;$i++) {
        $v = $c.st[$i]
        $bar = "#" * $v
        $pad = " " * (10-$v)
        $rtb.SelectionColor = $cCyan
        $line = "  {0,-14} {1,2}  [{2}{3}]`n"
        $rtb.AppendText(($line -f $S[$i],$v,$bar,$pad))
    }

    $total = 0
    foreach ($v in $c.st) { $total += $v }
    $rtb.AppendText("`n")
    $rtb.SelectionColor = $cMint
    $rtb.AppendText(("  TOTAL: {0}`n" -f $total))
    if ($c.hB) { $rtb.SelectionColor=$cYellow; $rtb.AppendText("  [Bruiser]    +2 Strength`n") }
    if ($c.hF) { $rtb.SelectionColor=$cYellow; $rtb.AppendText("  [Fast Shot]  +1 Agility`n") }
    if ($c.hG) { $rtb.SelectionColor=$cYellow; $rtb.AppendText("  [Gifted]     +1 all stats`n") }

    $rtb.AppendText("`n")
    $rtb.SelectionColor = $cLtGrn
    $rtb.AppendText("  TAGGED SKILLS`n")
    $rtb.AppendText("  ----------------------------`n")
    for ($i=0;$i -lt 3;$i++) {
        $rtb.SelectionColor = $cCyan
        $line = "  [{0,-12}]  {1}`n"
        $rtb.AppendText(($line -f $c.sk[$i],$c.sn[$i]))
    }

    $rtb.AppendText("`n")
    $rtb.SelectionColor = $cLtGrn
    $rtb.AppendText("  TRAITS`n")
    $rtb.AppendText("  ----------------------------`n")
    for ($i=0;$i -lt 2;$i++) {
        $rtb.SelectionColor = $cPurple
        $line = "  [{0,-14}]  {1}`n"
        $rtb.AppendText(($line -f $c.tk[$i],$c.tn[$i]))
    }

    $rtb.AppendText("`n")
    $rtb.SelectionColor = $cFade
    $rtb.AppendText("  Good luck out there, Wanderer.`n")
}

$btnR.Add_Click({ Show })
Show
[System.Windows.Forms.Application]::Run($form)
