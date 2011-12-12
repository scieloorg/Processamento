
 if l(['../bases/doi/doi'],v880)>0 then
	if ref(['../bases/doi/doi']l(['../bases/doi/doi'],v880),v999)<>'' then
		proc('d1000a1000{',(if v999^t='doi' then 'doi' fi),'{'),
		'd999',
		if v1000='doi' then
			('a999{',
				if v999^t='doi' then 
					v999^t,ref(['../bases/doi/doi']l(['../bases/doi/doi'],v880),v999),
				else
					v999,
				fi,
			'{'),
		else
			'a999{^tdoi',
			ref(['../bases/doi/doi']l(['../bases/doi/doi'],v880),v999),
			'{',
		fi,
	fi,
 fi,
