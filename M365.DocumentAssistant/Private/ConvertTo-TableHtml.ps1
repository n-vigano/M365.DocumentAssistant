function ConvertTo-TableHtml {
  [CmdletBinding()] param([Parameter(Mandatory)][ValidateNotNull()]$Data)
  $arr = if ($Data -is [System.Collections.IEnumerable] -and -not ($Data -is [string])) { @($Data) } else { @($Data) }
  if ($arr.Count -eq 0) { return '<p>No data</p>' }
  $cols = ($arr[0] | Get-Member -MemberType NoteProperty,Property).Name
  $th = ($cols | ForEach-Object { "<th>$_</th>" }) -join ''
  $rows = foreach($item in $arr){ $td = foreach($c in $cols){ $v = $item.$c; if ($null -eq $v){''} elseif ($v -is [DateTime]){ $v.ToString('s') } elseif ($v -is [System.Collections.IEnumerable] -and -not ($v -is [string])) { ($v | ForEach-Object { $_.ToString() }) -join ', ' } else { [string]$v } }; "<tr>" + (($td | ForEach-Object { "<td>$_</td>" }) -join '') + "</tr>" }
  return "<table class='table'><thead><tr>$th</tr></thead><tbody>" + ($rows -join '') + "</tbody></table>"
}
