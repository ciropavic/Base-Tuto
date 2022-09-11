RegisterNetEvent('esx:setJob')
AddEventHandler('esx:setJob', function(job)
	ESX.PlayerData.job = job
end)

RegisterNetEvent('esx:playerLoaded')
AddEventHandler('esx:playerLoaded', function(xPlayer)
	ESX.PlayerData = xPlayer
	ESX.PlayerLoaded = true
end)

function OpenBossMenu(society, close, options)
	options = options or {}
	local elements = {}

	ESX.TriggerServerCallback('esx_society:isBoss', function(isBoss)
		if isBoss then
			local defaultOptions = {
				withdraw = true,
				deposit = true,
				withdraw_black = false,
				deposit_black = false,
				wash = false,
				employees = true,
				employees_sec = false,
				grades = false
			}

			for k,v in pairs(defaultOptions) do
				if options[k] == nil then
					options[k] = v
				end
			end

			if options.withdraw then
				table.insert(elements, {label = _U('withdraw_society_money'), value = 'withdraw_society_money'})
			end

			if options.deposit then
				table.insert(elements, {label = _U('deposit_society_money'), value = 'deposit_money'})
			end

			if options.withdraw_black then
				table.insert(elements, {label = _U('withdraw_society_black_money'), value = 'withdraw_society_black_money'})
			end

			if options.deposit_black then
				table.insert(elements, {label = _U('deposit_society_black_money'), value = 'deposit_black_money'})
			end

			if options.wash then
				table.insert(elements, {label = _U('wash_money'), value = 'wash_money'})
			end

			if options.employees then
				table.insert(elements, {label = _U('employee_management'), value = 'manage_employees'})
			end

			if options.employees_sec then
				table.insert(elements, {label = _U('reserviste_management'), value = 'manage_reserviste'})
			end

			if options.grades then
				table.insert(elements, {label = _U('salary_management'), value = 'manage_grades'})
			end

			ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'boss_actions_' .. society, {
				title    = _U('boss_menu'),
				align    = 'top-left',
				elements = elements
			}, function(data, menu)
				if data.current.value == 'withdraw_society_money' then
					ESX.UI.Menu.Open('dialog', GetCurrentResourceName(), 'withdraw_society_money_amount_' .. society, {
						title = _U('withdraw_amount')
					}, function(data2, menu2)
						local amount = tonumber(data2.value)

						if amount == nil then
							ESX.ShowNotification(_U('invalid_amount'))
						else
							menu2.close()
							TriggerServerEvent('esx_society:withdrawMoney', society, amount)
						end
					end, function(data2, menu2)
						menu2.close()
					end)
				elseif data.current.value == 'deposit_money' then
					ESX.UI.Menu.Open('dialog', GetCurrentResourceName(), 'deposit_money_amount_' .. society, {
						title = _U('deposit_amount')
					}, function(data2, menu2)
						local amount = tonumber(data2.value)

						if amount == nil then
							ESX.ShowNotification(_U('invalid_amount'))
						else
							menu2.close()
							TriggerServerEvent('esx_society:depositMoney', society, amount)
						end
					end, function(data2, menu2)
						menu2.close()
					end)
				elseif data.current.value == 'withdraw_society_black_money' then
					ESX.UI.Menu.Open('dialog', GetCurrentResourceName(), 'withdraw_society_black_money_amount_' .. society, {
						title = _U('withdraw_amount')
					}, function(data2, menu2)
						local amount = tonumber(data2.value)

						if amount == nil then
							ESX.ShowNotification(_U('invalid_amount'))
						else
							menu2.close()
							TriggerServerEvent('esx_society:withdrawBlackMoney', society, amount)
						end
					end, function(data2, menu2)
						menu2.close()
					end)
				elseif data.current.value == 'deposit_black_money' then
					ESX.UI.Menu.Open('dialog', GetCurrentResourceName(), 'deposit_black_money_amount_' .. society, {
						title = _U('deposit_amount')
					}, function(data2, menu2)
						local amount = tonumber(data2.value)

						if amount == nil then
							ESX.ShowNotification(_U('invalid_amount'))
						else
							menu2.close()
							TriggerServerEvent('esx_society:depositBlackMoney', society, amount)
						end
					end, function(data2, menu2)
						menu2.close()
					end)
				elseif data.current.value == 'wash_money' then
					ESX.UI.Menu.Open('dialog', GetCurrentResourceName(), 'wash_money_amount_' .. society, {
						title = _U('wash_money_amount')
					}, function(data2, menu2)
						local amount = tonumber(data2.value)

						if amount == nil then
							ESX.ShowNotification(_U('invalid_amount'))
						else
							menu2.close()
							TriggerServerEvent('esx_society:washMoney', society, amount)
						end
					end, function(data2, menu2)
						menu2.close()
					end)
				elseif data.current.value == 'manage_employees' then
					OpenManageEmployeesMenu(society)
				elseif data.current.value == 'manage_reserviste' then
					OpenManageReservisteMenu(society)
				elseif data.current.value == 'manage_grades' then
					OpenManageGradesMenu(society)
				end
			end, function(data, menu)
				if close then
					close(data, menu)
				end
			end)
		end
	end, society)
end

function OpenManageEmployeesMenu(society)
	ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'manage_employees_' .. society, {
		title    = _U('employee_management'),
		align    = 'top-left',
		elements = {
			{label = _U('employee_list'), value = 'employee_list'},
			{label = _U('recruit'), value = 'recruit'}
	}}, function(data, menu)
		if data.current.value == 'employee_list' then
			OpenEmployeeList(society)
		elseif data.current.value == 'recruit' then
			OpenRecruitMenu(society)
		end
	end, function(data, menu)
		menu.close()
	end)
end

function OpenEmployeeList(society)
	ESX.TriggerServerCallback('esx_society:getEmployees', function(employees)

		local elements = {
			head = {_U('employee'), _U('grade'), _U('actions')},
			rows = {}
		}

		for i=1, #employees, 1 do
			local gradeLabel = (employees[i].job.grade_label == '' and employees[i].job.label or employees[i].job.grade_label)

			table.insert(elements.rows, {
				data = employees[i],
				cols = {
					employees[i].name,
					gradeLabel,
					'{{' .. _U('promote') .. '|promote}} {{' .. _U('fire') .. '|fire}}'
				}
			})
		end

		ESX.UI.Menu.Open('list', GetCurrentResourceName(), 'employee_list_' .. society, elements, function(data, menu)
			local employee = data.data

			if data.value == 'promote' then
				menu.close()
				OpenPromoteMenu(society, employee)
			elseif data.value == 'fire' then
				ESX.ShowNotification(_U('you_have_fired', employee.name))

				ESX.TriggerServerCallback('esx_society:setJob', function()
					OpenEmployeeList(society)
				end, employee.identifier, 'unemployed', 0, 'fire')
			end
		end, function(data, menu)
			menu.close()
			OpenManageEmployeesMenu(society)
		end)
	end, society)
end

function OpenRecruitMenu(society)
	ESX.TriggerServerCallback('esx_society:getOnlinePlayers', function(players)
		local elements = {}

		for i=1, #players, 1 do
			if players[i].job.name ~= society then
				table.insert(elements, {
					label = players[i].name,
					value = players[i].source,
					name = players[i].name,
					identifier = players[i].identifier
				})
			end
		end

		ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'recruit_' .. society, {
			title    = _U('recruiting'),
			align    = 'top-left',
			elements = elements
		}, function(data, menu)
			ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'recruit_confirm_' .. society, {
				title    = _U('do_you_want_to_recruit', data.current.name),
				align    = 'top-left',
				elements = {
					{label = _U('no'), value = 'no'},
					{label = _U('yes'), value = 'yes'}
			}}, function(data2, menu2)
				menu2.close()

				if data2.current.value == 'yes' then
					ESX.ShowNotification(_U('you_have_hired', data.current.name))

					ESX.TriggerServerCallback('esx_society:setJob', function()
						OpenRecruitMenu(society)
					end, data.current.identifier, society, 0, 'hire')
				end
			end, function(data2, menu2)
				menu2.close()
			end)
		end, function(data, menu)
			menu.close()
		end)
	end)
end

function OpenPromoteMenu(society, employee)
	ESX.TriggerServerCallback('esx_society:getJob', function(job)
		local elements = {}

		for i=1, #job.grades, 1 do
			local gradeLabel = (job.grades[i].label == '' and job.label or job.grades[i].label)

			table.insert(elements, {
				label = gradeLabel,
				value = job.grades[i].grade,
				selected = (employee.job.grade == job.grades[i].grade)
			})
		end

		ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'promote_employee_' .. society, {
			title    = _U('promote_employee', employee.name),
			align    = 'top-left',
			elements = elements
		}, function(data, menu)
			menu.close()
			ESX.ShowNotification(_U('you_have_promoted', employee.name, data.current.label))

			ESX.TriggerServerCallback('esx_society:setJob', function()
				OpenEmployeeList(society)
			end, employee.identifier, society, data.current.value, 'promote')
		end, function(data, menu)
			menu.close()
			OpenEmployeeList(society)
		end)
	end, society)
end

-- reserviste
function OpenManageReservisteMenu(society)
	ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'manage_employees_sec_' .. society, {
		title    = _U('reserviste_management'),
		align    = 'top-left',
		elements = {
			{label = _U('reserviste_list'), value = 'employee_list'},
			{label = _U('recruit'), value = 'recruit'}
	}}, function(data, menu)
		if data.current.value == 'employee_list' then
			OpenReservisteList(society)
		elseif data.current.value == 'recruit' then
			OpenRecruitSecMenu(society)
		end
	end, function(data, menu)
		menu.close()
	end)
end

function OpenReservisteList(society)
	ESX.TriggerServerCallback('esx_society:getEmployees2', function(employees)

		local elements = {
			head = {_U('reserviste'), _U('grade'), _U('actions')},
			rows = {}
		}

		for i=1, #employees, 1 do
			local grade2Label = (employees[i].job2.grade_label == '' and employees[i].job2.label or employees[i].job2.grade_label)

			table.insert(elements.rows, {
				data = employees[i],
				cols = {
					employees[i].name,
					grade2Label,
					'{{' .. _U('promote') .. '|promote}} {{' .. _U('fire') .. '|fire}}'
				}
			})
		end

		ESX.UI.Menu.Open('list', GetCurrentResourceName(), 'employee_list_sec_' .. society, elements, function(data, menu)
			local employee = data.data

			if data.value == 'promote' then
				menu.close()
				OpenPromoteSecMenu(society, employee)
			elseif data.value == 'fire' then
				ESX.ShowNotification(_U('you_have_fired', employee.name))

				ESX.TriggerServerCallback('esx_society:setJob2', function()
					OpenReservisteList(society)
				end, employee.identifier, 'unemployed2', 0, 'fire')
			end
		end, function(data, menu)
			menu.close()
			OpenManageReservisteMenu(society)
		end)
	end, society)
end

function OpenRecruitSecMenu(society)
	ESX.TriggerServerCallback('esx_society:getOnlinePlayers', function(players)
		local elements = {}

		for i=1, #players, 1 do
			if (players[i].job.name ~= society and players[i].job2.name ~= society) then
				table.insert(elements, {
					label = players[i].name,
					value = players[i].source,
					name = players[i].name,
					identifier = players[i].identifier
				})
			end
		end

		ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'recruit_sec_' .. society, {
			title    = _U('recruiting'),
			align    = 'top-left',
			elements = elements
		}, function(data, menu)
			ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'recruit_confirm_sec_' .. society, {
				title    = _U('do_you_want_to_recruit', data.current.name),
				align    = 'top-left',
				elements = {
					{label = _U('no'), value = 'no'},
					{label = _U('yes'), value = 'yes'}
			}}, function(data2, menu2)
				menu2.close()

				if data2.current.value == 'yes' then
					ESX.ShowNotification(_U('you_have_hired', data.current.name))

					ESX.TriggerServerCallback('esx_society:setJob2', function()
						OpenRecruitSecMenu(society)
					end, data.current.identifier, society, 0, 'hire')
				end
			end, function(data2, menu2)
				menu2.close()
			end)
		end, function(data, menu)
			menu.close()
		end)
	end)
end

function OpenPromoteSecMenu(society, employee)
	ESX.TriggerServerCallback('esx_society:getJob2', function(job2)
		local elements = {}

		for i=1, #job2.grades, 1 do
			local grade2Label = (job2.grades[i].label == '' and job2.label or job2.grades[i].label)

			table.insert(elements, {
				label = grade2Label,
				value = job2.grades[i].grade,
				selected = (employee.job2.grade == job2.grades[i].grade)
			})
		end

		ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'promote_employee_sec_' .. society, {
			title    = _U('promote_employee', employee.name),
			align    = 'top-left',
			elements = elements
		}, function(data, menu)
			menu.close()
			ESX.ShowNotification(_U('you_have_promoted', employee.name, data.current.label))

			ESX.TriggerServerCallback('esx_society:setJob2', function()
				OpenReservisteList(society)
			end, employee.identifier, society, data.current.value, 'promote')
		end, function(data, menu)
			menu.close()
			OpenReservisteList(society)
		end)
	end, society)
end



function OpenManageGradesMenu(society)
	ESX.TriggerServerCallback('esx_society:getJob', function(job)
		local elements = {}

		for i=1, #job.grades, 1 do
			local gradeLabel = (job.grades[i].label == '' and job.label or job.grades[i].label)

			table.insert(elements, {
				label = ('%s - <span style="color:green;">%s</span>'):format(gradeLabel, _U('money_generic', ESX.Math.GroupDigits(job.grades[i].salary))),
				value = job.grades[i].grade
			})
		end

		ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'manage_grades_' .. society, {
			title    = _U('salary_management'),
			align    = 'top-left',
			elements = elements
		}, function(data, menu)
			ESX.UI.Menu.Open('dialog', GetCurrentResourceName(), 'manage_grades_amount_' .. society, {
				title = _U('salary_amount')
			}, function(data2, menu2)

				local amount = tonumber(data2.value)

				if amount == nil then
					ESX.ShowNotification(_U('invalid_amount'))
				elseif amount > Config.MaxSalary then
					ESX.ShowNotification(_U('invalid_amount_max'))
				else
					menu2.close()

					ESX.TriggerServerCallback('esx_society:setJobSalary', function()
						OpenManageGradesMenu(society)
					end, society, data.current.value, amount)
				end
			end, function(data2, menu2)
				menu2.close()
			end)
		end, function(data, menu)
			menu.close()
		end)
	end, society)
end

AddEventHandler('esx_society:openBossMenu', function(society, close, options)
	OpenBossMenu(society, close, options)
end)

-- job2
function OpenBossMenu2(society, close, options)
	options = options or {}
	local elements = {}

	ESX.TriggerServerCallback('esx_society:isBoss2', function(isBoss)
		if isBoss then
			local defaultOptions = {
				withdraw = true,
				deposit = true,
				withdraw_black = true,
				deposit_black = true,
				wash = false,
				employees = true,
				grades = false
			}

			for k,v in pairs(defaultOptions) do
				if options[k] == nil then
					options[k] = v
				end
			end

			if options.withdraw then
				table.insert(elements, {label = _U('withdraw_money'), value = 'withdraw_society_money'})
			end

			if options.deposit then
				table.insert(elements, {label = _U('deposit_money'), value = 'deposit_money'})
			end

			if options.withdraw_black then
				table.insert(elements, {label = _U('withdraw_black_money'), value = 'withdraw_society_black_money'})
			end

			if options.deposit_black then
				table.insert(elements, {label = _U('deposit_black_money'), value = 'deposit_black_money'})
			end

			if options.wash then
				table.insert(elements, {label = _U('wash_money'), value = 'wash_money'})
			end

			if options.employees then
				table.insert(elements, {label = _U('members_management'), value = 'manage_employees'})
			end

			if options.grades then
				table.insert(elements, {label = _U('bounty_management'), value = 'manage_grades'})
			end

			ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'boss_actions_job2_' .. society, {
				title    = _U('leader_menu'),
				align    = 'top-left',
				elements = elements
			}, function(data, menu)
				if data.current.value == 'withdraw_society_money' then
					ESX.UI.Menu.Open('dialog', GetCurrentResourceName(), 'withdraw_money_amount_job2_' .. society, {
						title = _U('withdraw_amount')
					}, function(data2, menu2)
						local amount = tonumber(data2.value)

						if amount == nil then
							ESX.ShowNotification(_U('invalid_amount'))
						else
							menu2.close()
							TriggerServerEvent('esx_society:withdrawMoney', society, amount)
						end
					end, function(data2, menu2)
						menu2.close()
					end)
				elseif data.current.value == 'deposit_money' then
					ESX.UI.Menu.Open('dialog', GetCurrentResourceName(), 'deposit_money_amount_job2_' .. society, {
						title = _U('deposit_amount')
					}, function(data2, menu2)
						local amount = tonumber(data2.value)

						if amount == nil then
							ESX.ShowNotification(_U('invalid_amount'))
						else
							menu2.close()
							TriggerServerEvent('esx_society:depositMoney', society, amount)
						end
					end, function(data2, menu2)
						menu2.close()
					end)
				elseif data.current.value == 'withdraw_society_black_money' then
					ESX.UI.Menu.Open('dialog', GetCurrentResourceName(), 'withdraw_society_black_money_amount_' .. society, {
						title = _U('withdraw_amount')
					}, function(data2, menu2)
						local amount = tonumber(data2.value)

						if amount == nil then
							ESX.ShowNotification(_U('invalid_amount'))
						else
							menu2.close()
							TriggerServerEvent('esx_society:withdrawBlackMoney', society, amount)
						end
					end, function(data2, menu2)
						menu2.close()
					end)
				elseif data.current.value == 'deposit_black_money' then
					ESX.UI.Menu.Open('dialog', GetCurrentResourceName(), 'deposit_black_money_amount_' .. society, {
						title = _U('deposit_amount')
					}, function(data2, menu2)
						local amount = tonumber(data2.value)

						if amount == nil then
							ESX.ShowNotification(_U('invalid_amount'))
						else
							menu2.close()
							TriggerServerEvent('esx_society:depositBlackMoney', society, amount)
						end
					end, function(data2, menu2)
						menu2.close()
					end)
				elseif data.current.value == 'wash_money' then
					ESX.UI.Menu.Open('dialog', GetCurrentResourceName(), 'wash_money_amount_job2_' .. society, {
						title = _U('wash_money_amount')
					}, function(data2, menu2)
						local amount = tonumber(data2.value)

						if amount == nil then
							ESX.ShowNotification(_U('invalid_amount'))
						else
							menu2.close()
							TriggerServerEvent('esx_society:washMoney', society, amount)
						end
					end, function(data2, menu2)
						menu2.close()
					end)
				elseif data.current.value == 'manage_employees' then
					OpenManageEmployeesMenu2(society)
				elseif data.current.value == 'manage_grades' then
					OpenManageGradesMenu2(society)
				end
			end, function(data, menu)
				if close then
					close(data, menu)
				end
			end)
		end
	end, society)
end

function OpenManageEmployeesMenu2(society)
	ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'manage_employees_job2_' .. society, {
		title    = _U('members_management'),
		align    = 'top-left',
		elements = {
			{label = _U('members_list'), value = 'employee_list'},
			{label = _U('recruit'), value = 'recruit'}
	}}, function(data, menu)
		if data.current.value == 'employee_list' then
			OpenEmployeeList2(society)
		elseif data.current.value == 'recruit' then
			OpenRecruitMenu2(society)
		end
	end, function(data, menu)
		menu.close()
	end)
end

function OpenEmployeeList2(society)
	ESX.TriggerServerCallback('esx_society:getEmployees2', function(employees)

		local elements = {
			head = {_U('members'), _U('grade'), _U('actions')},
			rows = {}
		}

		for i=1, #employees, 1 do
			local grade2Label = (employees[i].job2.grade_label == '' and employees[i].job2.label or employees[i].job2.grade_label)

			table.insert(elements.rows, {
				data = employees[i],
				cols = {
					employees[i].name,
					grade2Label,
					'{{' .. _U('promote') .. '|promote}} {{' .. _U('fire') .. '|fire}}'
				}
			})
		end

		ESX.UI.Menu.Open('list', GetCurrentResourceName(), 'employee_list_job2_' .. society, elements, function(data, menu)
			local employee = data.data

			if data.value == 'promote' then
				menu.close()
				OpenPromoteMenu2(society, employee)
			elseif data.value == 'fire' then
				ESX.ShowNotification(_U('you_have_fired', employee.name))

				ESX.TriggerServerCallback('esx_society:setJob2', function()
					OpenEmployeeList2(society)
				end, employee.identifier, 'unemployed2', 0, 'fire')
			end
		end, function(data, menu)
			menu.close()
			OpenManageEmployeesMenu2(society)
		end)
	end, society)
end

function OpenRecruitMenu2(society)
	ESX.TriggerServerCallback('esx_society:getOnlinePlayers', function(players)
		local elements = {}

		for i=1, #players, 1 do
			if (players[i].job.name ~= society and players[i].job2.name ~= society) then
				table.insert(elements, {
					label = players[i].name,
					value = players[i].source,
					name = players[i].name,
					identifier = players[i].identifier
				})
			end
		end

		ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'recruit_job2_' .. society, {
			title    = _U('recruiting'),
			align    = 'top-left',
			elements = elements
		}, function(data, menu)
			ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'recruit_confirm_job2_' .. society, {
				title    = _U('do_you_want_to_recruit', data.current.name),
				align    = 'top-left',
				elements = {
					{label = _U('no'), value = 'no'},
					{label = _U('yes'), value = 'yes'}
			}}, function(data2, menu2)
				menu2.close()

				if data2.current.value == 'yes' then
					ESX.ShowNotification(_U('you_have_hired', data.current.name))

					ESX.TriggerServerCallback('esx_society:setJob2', function()
						OpenRecruitMenu2(society)
					end, data.current.identifier, society, 0, 'hire')
				end
			end, function(data2, menu2)
				menu2.close()
			end)
		end, function(data, menu)
			menu.close()
		end)
	end)
end

function OpenPromoteMenu2(society, employee)
	ESX.TriggerServerCallback('esx_society:getJob2', function(job2)
		local elements = {}

		for i=1, #job2.grades, 1 do
			local grade2Label = (job2.grades[i].label == '' and job2.label or job2.grades[i].label)

			table.insert(elements, {
				label = grade2Label,
				value = job2.grades[i].grade,
				selected = (employee.job2.grade == job2.grades[i].grade)
			})
		end

		ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'promote_employee_job2_' .. society, {
			title    = _U('promote_employee', employee.name),
			align    = 'top-left',
			elements = elements
		}, function(data, menu)
			menu.close()
			ESX.ShowNotification(_U('you_have_promoted', employee.name, data.current.label))

			ESX.TriggerServerCallback('esx_society:setJob2', function()
				OpenEmployeeList2(society)
			end, employee.identifier, society, data.current.value, 'promote')
		end, function(data, menu)
			menu.close()
			OpenEmployeeList2(society)
		end)
	end, society)
end

function OpenManageGradesMenu2(society)
	ESX.TriggerServerCallback('esx_society:getJob2', function(job2)
		local elements = {}

		for i=1, #job2.grades, 1 do
			local grade2Label = (job2.grades[i].label == '' and job2.label or job2.grades[i].label)

			table.insert(elements, {
				label = ('%s - <span style="color:green;">%s</span>'):format(grade2Label, _U('money_generic', ESX.Math.GroupDigits(job2.grades[i].salary))),
				value = job2.grades[i].grade
			})
		end

		ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'manage_grades_job2_' .. society, {
			title    = _U('bounty_management'),
			align    = 'top-left',
			elements = elements
		}, function(data, menu)
			ESX.UI.Menu.Open('dialog', GetCurrentResourceName(), 'manage_grades_amount_job2_' .. society, {
				title = _U('bounty_amount')
			}, function(data2, menu2)

				local amount = tonumber(data2.value)

				if amount == nil then
					ESX.ShowNotification(_U('invalid_amount'))
				elseif amount > Config.MaxSalary then
					ESX.ShowNotification(_U('invalid_amount_max'))
				else
					menu2.close()

					ESX.TriggerServerCallback('esx_society:setJobSalary2', function()
						OpenManageGradesMenu2(society)
					end, society, data.current.value, amount)
				end
			end, function(data2, menu2)
				menu2.close()
			end)
		end, function(data, menu)
			menu.close()
		end)
	end, society)
end

AddEventHandler('esx_society:openBossMenu2', function(society, close, options)
	OpenBossMenu2(society, close, options)
end)