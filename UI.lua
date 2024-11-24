local UserInputService = game:GetService("UserInputService")
local LocalPlayer = game:GetService("Players").LocalPlayer
local TweenService = game:GetService("TweenService")
local HttpService = game:GetService("HttpService")
local RunService = game:GetService("RunService")
local CoreGui = RunService:IsStudio() and LocalPlayer:WaitForChild("PlayerGui") or game:GetService("CoreGui")
local Camera = workspace.CurrentCamera
local Mouse = LocalPlayer:GetMouse()
local DisableDragging = false
local ShouldReverse = true
local Transitioning = false

_G.ThemeJourne = _G.ThemeJourne or "Coffee"

Utilities = {}

function Utilities.NewObject(className, properties)
	assert(type(className) == "string", "ClassName must be a string")
	assert(type(properties) == "table", "Properties must be a table")

	local success, result = pcall(function()
		local object = Instance.new(className)
		for property, value in pairs(properties) do
			object[property] = value
		end
		return object
	end)

	if success then
		return result
	else
		warn("Failed to create object:", result)
		return nil
	end
end

Journe = {
	Themes = {
		Dark = {
			Background = Color3.fromRGB(15, 15, 15),
			Seperators = Color3.fromRGB(19, 19, 19),
			ImageNText = {
				Light = Color3.fromRGB(255, 255, 255),

				Dark = Color3.fromRGB(106, 106, 106),

				ReallyDark = Color3.fromRGB(44, 44, 44)
			},
			Group = {
				Title = Color3.fromRGB(200, 200, 200),
				Background = Color3.fromRGB(20, 20, 20),

				Items = {
					ImageNText = {
						Normal = Color3.fromRGB(126, 126, 126),
						Hover = Color3.fromRGB(226, 226, 226)
					},

					Stroke = {
						Normal = Color3.fromRGB(35, 35, 35),
						Hover = Color3.fromRGB(45, 45, 45)
					},

					ExtraArea = Color3.fromRGB(31, 31, 31),

					Toggle = {
						ToggleBackground = {
							Off = Color3.fromRGB(61, 61, 61),
							On = Color3.fromRGB(122, 122, 122)
						},
						Switch = {
							Off = Color3.fromRGB(91, 91, 91),
							On = Color3.fromRGB(182, 182, 182)
						}
					},
					Slider = {
						SliderBackground = Color3.fromRGB(86, 86, 86)
					},
					Dropdown = {
						DropdownBackground = Color3.fromRGB(24, 24, 24),
						Backdrop = Color3.fromRGB(20, 20, 20)
					}
				}
			},
			Tabs = {
				Background = {
					Inactive = Color3.fromRGB(20, 20, 20),
					HoverNActive = Color3.fromRGB(25, 25, 25)
				},
				Stroke = {
					Inactive = Color3.fromRGB(24, 24, 24),
					HoverNActive = Color3.fromRGB(29, 29, 29)
				},
				Text = Color3.fromRGB(111, 111, 111)
			}
		},

		Light = {
			Background = Color3.fromRGB(240, 240, 240),
			Seperators = Color3.fromRGB(220, 220, 220),
			ImageNText = {
				Light = Color3.fromRGB(0, 0, 0),
				Dark = Color3.fromRGB(85, 85, 85),
				ReallyDark = Color3.fromRGB(150, 150, 150),
			},
			Group = {
				Title = Color3.fromRGB(50, 50, 50),
				Background = Color3.fromRGB(255, 255, 255),

				Items = {
					ImageNText = {
						Normal = Color3.fromRGB(70, 70, 70),
						Hover = Color3.fromRGB(30, 30, 30)
					},

					Stroke = {
						Normal = Color3.fromRGB(180, 180, 180),
						Hover = Color3.fromRGB(160, 160, 160)
					},

					ExtraArea = Color3.fromRGB(225, 225, 225),

					Toggle = {
						ToggleBackground = {
							Off = Color3.fromRGB(200, 200, 200),
							On = Color3.fromRGB(100, 100, 100)
						},
						Switch = {
							Off = Color3.fromRGB(164, 164, 164),
							On = Color3.fromRGB(73, 73, 73)
						}
					},
					Slider = {
						SliderBackground = Color3.fromRGB(190, 190, 190)
					},
					Dropdown = {
						DropdownBackground = Color3.fromRGB(230, 230, 230),
						Backdrop = Color3.fromRGB(200, 200, 200)
					}
				}
			},
			Tabs = {
				Background = {
					Inactive = Color3.fromRGB(235, 235, 235),
					HoverNActive = Color3.fromRGB(245, 245, 245)
				},
				Stroke = {
					Inactive = Color3.fromRGB(230, 230, 230),
					HoverNActive = Color3.fromRGB(240, 240, 240)
				},
				Text = Color3.fromRGB(50, 50, 50)
			}
		},

		Barbie = {
			Background = Color3.fromRGB(255, 245, 250), 
			Seperators = Color3.fromRGB(255, 182, 193), 
			ImageNText = {
				Light = Color3.fromRGB(0, 0, 0), 
				Dark = Color3.fromRGB(51, 51, 51), 
				ReallyDark = Color3.fromRGB(25, 25, 25) 
			},
			Group = {
				Title = Color3.fromRGB(51, 51, 51), 
				Background = Color3.fromRGB(255, 235, 241), 
				Items = {
					ImageNText = {
						Normal = Color3.fromRGB(75, 75, 75), 
						Hover = Color3.fromRGB(255, 51, 153) 
					},
					Stroke = {
						Normal = Color3.fromRGB(255, 192, 203), 
						Hover = Color3.fromRGB(255, 105, 180) 
					},
					ExtraArea = Color3.fromRGB(255, 240, 245), 
					Toggle = {
						ToggleBackground = {
							Off = Color3.fromRGB(200, 200, 200), 
							On = Color3.fromRGB(255, 51, 153) 
						},
						Switch = {
							Off = Color3.fromRGB(255, 255, 255), 
							On = Color3.fromRGB(255, 255, 255) 
						}
					},
					Slider = {
						SliderBackground = Color3.fromRGB(255, 51, 153) 
					},
					Dropdown = {
						DropdownBackground = Color3.fromRGB(255, 250, 252), 
						Backdrop = Color3.fromRGB(255, 245, 250) 
					}
				}
			},
			Tabs = {
				Background = {
					Inactive = Color3.fromRGB(255, 240, 245), 
					HoverNActive = Color3.fromRGB(255, 220, 230) 
				},
				Stroke = {
					Inactive = Color3.fromRGB(255, 192, 203), 
					HoverNActive = Color3.fromRGB(255, 105, 180) 
				},
				Text = Color3.fromRGB(51, 51, 51) 
			}
		},

		Sunset = {
			Background = Color3.fromRGB(35, 15, 45), 
			Seperators = Color3.fromRGB(45, 20, 55), 
			ImageNText = {
				Light = Color3.fromRGB(255, 255, 255), 
				Dark = Color3.fromRGB(255, 170, 100), 
				ReallyDark = Color3.fromRGB(150, 50, 60) 
			},
			Group = {
				Title = Color3.fromRGB(255, 190, 140), 
				Background = Color3.fromRGB(40, 17, 50), 
				Items = {
					ImageNText = {
						Normal = Color3.fromRGB(255, 150, 90), 
						Hover = Color3.fromRGB(255, 210, 170) 
					},
					Stroke = {
						Normal = Color3.fromRGB(70, 25, 85), 
						Hover = Color3.fromRGB(90, 35, 105) 
					},
					ExtraArea = Color3.fromRGB(50, 20, 60), 
					Toggle = {
						ToggleBackground = {
							Off = Color3.fromRGB(70, 25, 85), 
							On = Color3.fromRGB(255, 140, 80) 
						},
						Switch = {
							Off = Color3.fromRGB(120, 40, 140), 
							On = Color3.fromRGB(255, 180, 120) 
						}
					},
					Slider = {
						SliderBackground = Color3.fromRGB(255, 160, 100) 
					},
					Dropdown = {
						DropdownBackground = Color3.fromRGB(45, 18, 55), 
						Backdrop = Color3.fromRGB(35, 15, 45) 
					}
				}
			},
			Tabs = {
				Background = {
					Inactive = Color3.fromRGB(40, 17, 50), 
					HoverNActive = Color3.fromRGB(50, 20, 60) 
				},
				Stroke = {
					Inactive = Color3.fromRGB(60, 22, 70), 
					HoverNActive = Color3.fromRGB(80, 30, 90) 
				},
				Text = Color3.fromRGB(255, 170, 110) 
			}
		},

		Ocean = {
			Background = Color3.fromRGB(15, 25, 35), 
			Seperators = Color3.fromRGB(20, 35, 45), 
			ImageNText = {
				Light = Color3.fromRGB(255, 255, 255), 
				Dark = Color3.fromRGB(100, 200, 255), 
				ReallyDark = Color3.fromRGB(40, 90, 140) 
			},
			Group = {
				Title = Color3.fromRGB(130, 210, 255), 
				Background = Color3.fromRGB(18, 30, 40), 
				Items = {
					ImageNText = {
						Normal = Color3.fromRGB(90, 180, 255), 
						Hover = Color3.fromRGB(150, 220, 255) 
					},
					Stroke = {
						Normal = Color3.fromRGB(25, 45, 65), 
						Hover = Color3.fromRGB(35, 65, 85) 
					},
					ExtraArea = Color3.fromRGB(20, 35, 50), 
					Toggle = {
						ToggleBackground = {
							Off = Color3.fromRGB(30, 50, 70), 
							On = Color3.fromRGB(65, 170, 255) 
						},
						Switch = {
							Off = Color3.fromRGB(60, 100, 140), 
							On = Color3.fromRGB(130, 210, 255) 
						}
					},
					Slider = {
						SliderBackground = Color3.fromRGB(65, 170, 255) 
					},
					Dropdown = {
						DropdownBackground = Color3.fromRGB(20, 35, 45), 
						Backdrop = Color3.fromRGB(15, 25, 35) 
					}
				}
			},
			Tabs = {
				Background = {
					Inactive = Color3.fromRGB(18, 30, 40), 
					HoverNActive = Color3.fromRGB(22, 38, 48) 
				},
				Stroke = {
					Inactive = Color3.fromRGB(25, 45, 65), 
					HoverNActive = Color3.fromRGB(35, 65, 85) 
				},
				Text = Color3.fromRGB(100, 190, 255) 
			}
		},

		Discord = {
			Background = Color3.fromRGB(54, 57, 63), 
			Seperators = Color3.fromRGB(47, 49, 54), 
			ImageNText = {
				Light = Color3.fromRGB(255, 255, 255), 
				Dark = Color3.fromRGB(142, 146, 151), 
				ReallyDark = Color3.fromRGB(114, 118, 125) 
			},
			Group = {
				Title = Color3.fromRGB(255, 255, 255), 
				Background = Color3.fromRGB(47, 49, 54), 
				Items = {
					ImageNText = {
						Normal = Color3.fromRGB(142, 146, 151), 
						Hover = Color3.fromRGB(255, 255, 255) 
					},
					Stroke = {
						Normal = Color3.fromRGB(64, 68, 75), 
						Hover = Color3.fromRGB(75, 78, 85) 
					},
					ExtraArea = Color3.fromRGB(41, 43, 47), 
					Toggle = {
						ToggleBackground = {
							Off = Color3.fromRGB(64, 68, 75), 
							On = Color3.fromRGB(88, 101, 242) 
						},
						Switch = {
							Off = Color3.fromRGB(142, 146, 151), 
							On = Color3.fromRGB(255, 255, 255) 
						}
					},
					Slider = {
						SliderBackground = Color3.fromRGB(88, 101, 242) 
					},
					Dropdown = {
						DropdownBackground = Color3.fromRGB(47, 49, 54), 
						Backdrop = Color3.fromRGB(41, 43, 47) 
					}
				}
			},
			Tabs = {
				Background = {
					Inactive = Color3.fromRGB(47, 49, 54), 
					HoverNActive = Color3.fromRGB(54, 57, 63) 
				},
				Stroke = {
					Inactive = Color3.fromRGB(64, 68, 75), 
					HoverNActive = Color3.fromRGB(75, 78, 85) 
				},
				Text = Color3.fromRGB(142, 146, 151) 
			}
		},

		Halloween = {
			Background = Color3.fromRGB(20, 20, 25), 
			Seperators = Color3.fromRGB(30, 25, 35), 
			ImageNText = {
				Light = Color3.fromRGB(255, 255, 255), 
				Dark = Color3.fromRGB(255, 140, 0), 
				ReallyDark = Color3.fromRGB(111, 0, 177) 
			},
			Group = {
				Title = Color3.fromRGB(255, 117, 24), 
				Background = Color3.fromRGB(25, 22, 30), 
				Items = {
					ImageNText = {
						Normal = Color3.fromRGB(255, 140, 0), 
						Hover = Color3.fromRGB(193, 82, 255) 
					},
					Stroke = {
						Normal = Color3.fromRGB(50, 30, 60), 
						Hover = Color3.fromRGB(70, 40, 90) 
					},
					ExtraArea = Color3.fromRGB(30, 25, 35), 
					Toggle = {
						ToggleBackground = {
							Off = Color3.fromRGB(50, 30, 60), 
							On = Color3.fromRGB(255, 117, 24) 
						},
						Switch = {
							Off = Color3.fromRGB(90, 50, 120), 
							On = Color3.fromRGB(255, 170, 0) 
						}
					},
					Slider = {
						SliderBackground = Color3.fromRGB(255, 117, 24) 
					},
					Dropdown = {
						DropdownBackground = Color3.fromRGB(25, 22, 30), 
						Backdrop = Color3.fromRGB(20, 20, 25) 
					}
				}
			},
			Tabs = {
				Background = {
					Inactive = Color3.fromRGB(25, 22, 30), 
					HoverNActive = Color3.fromRGB(35, 28, 40) 
				},
				Stroke = {
					Inactive = Color3.fromRGB(50, 30, 60), 
					HoverNActive = Color3.fromRGB(70, 40, 90) 
				},
				Text = Color3.fromRGB(255, 140, 0) 
			}
		},

		Arctic = {
			Background = Color3.fromRGB(235, 245, 255), 
			Seperators = Color3.fromRGB(220, 235, 255), 
			ImageNText = {
				Light = Color3.fromRGB(0, 0, 0), 
				Dark = Color3.fromRGB(140, 180, 255), 
				ReallyDark = Color3.fromRGB(80, 140, 255) 
			},
			Group = {
				Title = Color3.fromRGB(100, 150, 255), 
				Background = Color3.fromRGB(240, 248, 255), 
				Items = {
					ImageNText = {
						Normal = Color3.fromRGB(130, 170, 255), 
						Hover = Color3.fromRGB(80, 140, 255) 
					},
					Stroke = {
						Normal = Color3.fromRGB(200, 225, 255), 
						Hover = Color3.fromRGB(180, 215, 255) 
					},
					ExtraArea = Color3.fromRGB(245, 250, 255), 
					Toggle = {
						ToggleBackground = {
							Off = Color3.fromRGB(200, 225, 255), 
							On = Color3.fromRGB(100, 150, 255) 
						},
						Switch = {
							Off = Color3.fromRGB(255, 255, 255), 
							On = Color3.fromRGB(255, 255, 255) 
						}
					},
					Slider = {
						SliderBackground = Color3.fromRGB(100, 150, 255) 
					},
					Dropdown = {
						DropdownBackground = Color3.fromRGB(240, 248, 255), 
						Backdrop = Color3.fromRGB(235, 245, 255) 
					}
				}
			},
			Tabs = {
				Background = {
					Inactive = Color3.fromRGB(240, 248, 255), 
					HoverNActive = Color3.fromRGB(230, 240, 255) 
				},
				Stroke = {
					Inactive = Color3.fromRGB(200, 225, 255), 
					HoverNActive = Color3.fromRGB(180, 215, 255) 
				},
				Text = Color3.fromRGB(100, 150, 255) 
			}
		},

		Matrix = {
			Background = Color3.fromRGB(0, 10, 0), 
			Seperators = Color3.fromRGB(0, 20, 0), 
			ImageNText = {
				Light = Color3.fromRGB(0, 255, 0), 
				Dark = Color3.fromRGB(0, 180, 0), 
				ReallyDark = Color3.fromRGB(0, 100, 0) 
			},
			Group = {
				Title = Color3.fromRGB(0, 255, 0), 
				Background = Color3.fromRGB(5, 15, 5), 
				Items = {
					ImageNText = {
						Normal = Color3.fromRGB(0, 200, 0), 
						Hover = Color3.fromRGB(0, 255, 0) 
					},
					Stroke = {
						Normal = Color3.fromRGB(0, 40, 0), 
						Hover = Color3.fromRGB(0, 60, 0) 
					},
					ExtraArea = Color3.fromRGB(10, 20, 10), 
					Toggle = {
						ToggleBackground = {
							Off = Color3.fromRGB(0, 40, 0), 
							On = Color3.fromRGB(0, 255, 0) 
						},
						Switch = {
							Off = Color3.fromRGB(0, 100, 0), 
							On = Color3.fromRGB(0, 255, 0) 
						}
					},
					Slider = {
						SliderBackground = Color3.fromRGB(0, 255, 0) 
					},
					Dropdown = {
						DropdownBackground = Color3.fromRGB(5, 15, 5), 
						Backdrop = Color3.fromRGB(0, 10, 0) 
					}
				}
			},
			Tabs = {
				Background = {
					Inactive = Color3.fromRGB(5, 15, 5), 
					HoverNActive = Color3.fromRGB(10, 20, 10) 
				},
				Stroke = {
					Inactive = Color3.fromRGB(0, 40, 0), 
					HoverNActive = Color3.fromRGB(0, 60, 0) 
				},
				Text = Color3.fromRGB(0, 200, 0) 
			}
		},

		Blossom = {
			Background = Color3.fromRGB(255, 250, 250), 
			Seperators = Color3.fromRGB(255, 235, 235), 
			ImageNText = {
				Light = Color3.fromRGB(255, 255, 255), 
				Dark = Color3.fromRGB(255, 182, 193), 
				ReallyDark = Color3.fromRGB(199, 21, 133) 
			},
			Group = {
				Title = Color3.fromRGB(255, 105, 180), 
				Background = Color3.fromRGB(255, 245, 245), 
				Items = {
					ImageNText = {
						Normal = Color3.fromRGB(219, 112, 147), 
						Hover = Color3.fromRGB(255, 192, 203) 
					},
					Stroke = {
						Normal = Color3.fromRGB(144, 238, 144), 
						Hover = Color3.fromRGB(152, 251, 152) 
					},
					ExtraArea = Color3.fromRGB(255, 240, 245), 
					Toggle = {
						ToggleBackground = {
							Off = Color3.fromRGB(230, 230, 230), 
							On = Color3.fromRGB(255, 182, 193) 
						},
						Switch = {
							Off = Color3.fromRGB(255, 255, 255), 
							On = Color3.fromRGB(255, 105, 180) 
						}
					},
					Slider = {
						SliderBackground = Color3.fromRGB(255, 182, 193) 
					},
					Dropdown = {
						DropdownBackground = Color3.fromRGB(255, 245, 245), 
						Backdrop = Color3.fromRGB(255, 250, 250) 
					}
				}
			},
			Tabs = {
				Background = {
					Inactive = Color3.fromRGB(255, 245, 245), 
					HoverNActive = Color3.fromRGB(255, 228, 225) 
				},
				Stroke = {
					Inactive = Color3.fromRGB(255, 240, 245), 
					HoverNActive = Color3.fromRGB(255, 228, 225) 
				},
				Text = Color3.fromRGB(219, 112, 147) 
			}
		},

		Galaxy = {
			Background = Color3.fromRGB(13, 2, 33), 
			Seperators = Color3.fromRGB(22, 11, 44), 
			ImageNText = {
				Light = Color3.fromRGB(255, 255, 255), 
				Dark = Color3.fromRGB(147, 112, 219), 
				ReallyDark = Color3.fromRGB(75, 0, 130) 
			},
			Group = {
				Title = Color3.fromRGB(255, 255, 255), 
				Background = Color3.fromRGB(17, 5, 39), 
				Items = {
					ImageNText = {
						Normal = Color3.fromRGB(138, 43, 226), 
						Hover = Color3.fromRGB(216, 191, 216) 
					},
					Stroke = {
						Normal = Color3.fromRGB(25, 13, 47), 
						Hover = Color3.fromRGB(48, 25, 92) 
					},
					ExtraArea = Color3.fromRGB(20, 8, 43), 
					Toggle = {
						ToggleBackground = {
							Off = Color3.fromRGB(47, 0, 100), 
							On = Color3.fromRGB(123, 104, 238) 
						},
						Switch = {
							Off = Color3.fromRGB(147, 112, 219), 
							On = Color3.fromRGB(255, 255, 255) 
						}
					},
					Slider = {
						SliderBackground = Color3.fromRGB(148, 0, 211) 
					},
					Dropdown = {
						DropdownBackground = Color3.fromRGB(17, 5, 39), 
						Backdrop = Color3.fromRGB(13, 2, 33) 
					}
				}
			},
			Tabs = {
				Background = {
					Inactive = Color3.fromRGB(17, 5, 39), 
					HoverNActive = Color3.fromRGB(22, 11, 44) 
				},
				Stroke = {
					Inactive = Color3.fromRGB(25, 13, 47), 
					HoverNActive = Color3.fromRGB(48, 25, 92) 
				},
				Text = Color3.fromRGB(147, 112, 219) 
			}
		},

		Coffee = {
			Background = Color3.fromRGB(43, 27, 20), 
			Seperators = Color3.fromRGB(54, 34, 25), 
			ImageNText = {
				Light = Color3.fromRGB(255, 248, 220), 
				Dark = Color3.fromRGB(139, 69, 19), 
				ReallyDark = Color3.fromRGB(101, 67, 33) 
			},
			Group = {
				Title = Color3.fromRGB(210, 180, 140), 
				Background = Color3.fromRGB(47, 30, 22), 
				Items = {
					ImageNText = {
						Normal = Color3.fromRGB(160, 120, 80), 
						Hover = Color3.fromRGB(205, 175, 145) 
					},
					Stroke = {
						Normal = Color3.fromRGB(65, 40, 30), 
						Hover = Color3.fromRGB(85, 50, 35) 
					},
					ExtraArea = Color3.fromRGB(50, 33, 25), 
					Toggle = {
						ToggleBackground = {
							Off = Color3.fromRGB(65, 40, 30), 
							On = Color3.fromRGB(139, 69, 19) 
						},
						Switch = {
							Off = Color3.fromRGB(160, 120, 80), 
							On = Color3.fromRGB(210, 180, 140) 
						}
					},
					Slider = {
						SliderBackground = Color3.fromRGB(139, 69, 19) 
					},
					Dropdown = {
						DropdownBackground = Color3.fromRGB(47, 30, 22), 
						Backdrop = Color3.fromRGB(43, 27, 20) 
					}
				}
			},
			Tabs = {
				Background = {
					Inactive = Color3.fromRGB(47, 30, 22), 
					HoverNActive = Color3.fromRGB(54, 34, 25) 
				},
				Stroke = {
					Inactive = Color3.fromRGB(65, 40, 30), 
					HoverNActive = Color3.fromRGB(85, 50, 35) 
				},
				Text = Color3.fromRGB(160, 120, 80) 
			}
		}
	},
	SelectedTheme = _G.ThemeJourne,
	Connections = {},
	SaveCfg = false,
	Elements = {},
	Core = {
		Main = Utilities.NewObject("ScreenGui", {
			Parent = nil,
			IgnoreGuiInset = true,
			ScreenInsets = Enum.ScreenInsets.DeviceSafeInsets,
			Name = "Journe.Lib",
			ResetOnSpawn = false,
			DisplayOrder = 214748364,

		}),

		Notifications = Utilities.NewObject("Frame", {
			Parent = nil,
			Name = "Notifications",
			BorderSizePixel = 0,
			BackgroundColor3 = Color3.fromRGB(255, 255, 255),
			AnchorPoint = Vector2.new(1, 1),
			Size = UDim2.new(0, 200, 70, 0),
			Position = UDim2.new(1, 10, 1, 0),
			BorderColor3 = Color3.fromRGB(0, 0, 0),
			BackgroundTransparency = 1
		}),

		NotificationsPadding = Utilities.NewObject("UIPadding", {
			Parent = nil,
			Name = "NotificationsPadding",
			PaddingLeft = UDim.new(0, 5),
			PaddingBottom = UDim.new(0, 5)
		}),

		NotificationsLayout = Utilities.NewObject("UIListLayout", {
			Parent = nil,
			Name = "UIPageLayout",
			FillDirection = Enum.FillDirection.Vertical,
			VerticalAlignment = Enum.VerticalAlignment.Bottom,
			HorizontalAlignment = Enum.HorizontalAlignment.Right,
			SortOrder = Enum.SortOrder.LayoutOrder,
			Padding = UDim.new(0, 5)
		})
	}
}

function Utilities.Tween(object, Settings)
	Settings = Utilities.Settings({
		Goal = {},
		Duration = 0.15,
		Callback = function() end,
		EasingStyle = Enum.EasingStyle.Sine,
		EasingDirection = Enum.EasingDirection.Out
	}, Settings or {})
	assert(object and Settings.Goal, "Object and goal properties are required for tweening")

	local tweenInfo = TweenInfo.new(
		Settings.Duration,
		Settings.EasingStyle,
		Settings.EasingDirection
	)

	local tween = TweenService:Create(object, tweenInfo, Settings.Goal)
	tween:Play()

	tween.Completed:Once(Settings.Callback)

	return tween
end

function Journe:IsRunning()
	if gethui then
		return Journe.Core.Main.Parent == gethui()
	else
		return Journe.Core.Main.Parent == CoreGui
	end
end

if syn then
	syn.protect_gui(Journe.Core.Main)
	Journe.Core.Main.Parent = CoreGui
else
	Journe.Core.Main.Parent = CoreGui
end

for _, Interface in ipairs(CoreGui:GetChildren()) do
	if Interface.Name == Journe.Core.Main.Name and Interface ~= Journe.Core.Main then
		Interface:Destroy()
	end
end

local function AddConnection(Signal, Function)
	if (not Journe:IsRunning()) then
		return
	end
	local SignalConnect = Signal:Connect(Function)
	table.insert(Journe.Connections, SignalConnect)
	return SignalConnect
end

function Utilities.Settings(defaults, options)
	options = options or {}
	local merged = {}

	for k, v in pairs(defaults) do
		merged[k] = v
	end

	for k, v in pairs(options) do
		if defaults[k] ~= nil then
			merged[k] = v
		end
	end

	return merged
end

local function CreateCursor(frame, cursorId)
	assert(frame and cursorId, "Frame and cursorId are required")
	assert(frame:IsA("GuiObject"), "Frame must be a GuiObject")
	assert(type(cursorId) == "string" or type(cursorId) == "number", "CursorId must be a string or number")

	local cursor = Utilities.NewObject("ImageLabel", {
		Name = "CustomCursor-" .. cursorId,
		Size = UDim2.new(0, 20, 0, 20),
		BackgroundTransparency = 1,
		Image = "rbxassetid://" .. cursorId,
		Parent = frame.Parent,
		ZIndex = 2147483647
	})

	RunService.RenderStepped:Connect(function()
		if Journe.SelectedTheme == "Light" or Journe.SelectedTheme == "Arctic" then
			cursor.ImageColor3 = Color3.new(0, 0, 0)
		else
			cursor.ImageColor3 = Color3.new(1, 1, 1)
		end

		local mouse = Mouse
		local framePos = frame.AbsolutePosition
		local frameSize = frame.AbsoluteSize

		local isInFrame = mouse.X >= framePos.X 
			and mouse.X <= framePos.X + frameSize.X
			and mouse.Y >= framePos.Y 
			and mouse.Y <= framePos.Y + frameSize.Y
			and frame.Visible

		cursor.Visible = isInFrame
		UserInputService.MouseIconEnabled = not isInFrame

		if isInFrame then
			cursor.Position = UDim2.new(
				0, mouse.X - framePos.X - 2,
				0, mouse.Y - framePos.Y - 2
			)
		end
	end)

	return cursor
end

local function Dragify(frame, Visible)
	assert(frame:IsA("GuiObject"), "Frame must be a GuiObject")

	local dragging, dragInput, mousePosition, framePosition

	local function updateDrag(input)
		local delta = input.Position - mousePosition
		local newPosition = UDim2.new(
			framePosition.X.Scale,
			framePosition.X.Offset + delta.X,
			framePosition.Y.Scale,
			framePosition.Y.Offset + delta.Y
		)

		Utilities.Tween(frame, {
			Goal = {Position = newPosition},
			Duration = 0.05,
			EasingStyle = Enum.EasingStyle.Exponential,
			EasingDirection = Enum.EasingDirection.Out
		})
	end

	frame.InputBegan:Connect(function(input)
		if (input.UserInputType == Enum.UserInputType.MouseButton1 
			or input.UserInputType == Enum.UserInputType.Touch)
			and not DisableDragging and Visible.Visible == true then

			dragging = true
			mousePosition = input.Position
			framePosition = frame.Position

			if UserInputService.TouchEnabled  and Visible.Visible == true then
				UserInputService.MouseBehavior = Enum.MouseBehavior.LockCenter
				UserInputService.ModalEnabled = true
				Camera.CameraType = Enum.CameraType.Scriptable
			end

			input.Changed:Connect(function()
				if input.UserInputState == Enum.UserInputState.End  and Visible.Visible == true then
					dragging = false
					if UserInputService.TouchEnabled then
						UserInputService.MouseBehavior = Enum.MouseBehavior.Default
						UserInputService.ModalEnabled = false
						Camera.CameraType = Enum.CameraType.Custom
					end
				end
			end)
		end
	end)

	frame.InputChanged:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.Touch 
			or input.UserInputType == Enum.UserInputType.MouseMovement and Visible.Visible == true then
			dragInput = input
		end
	end)

	UserInputService.InputChanged:Connect(function(input)
		if input == dragInput and dragging and not DisableDragging and Visible.Visible == true then
			updateDrag(input)
		end
	end)
end

local function Transition(frames, positionOffsetY, transparencyGoal, duration, transparencyDuration, delay, reverse)

	assert(frames and #frames > 0, "frames must be a non-empty array")

	duration = duration or 1
	transparencyDuration = transparencyDuration or 0.5
	delay = delay or 0.1

	local startIndex, endIndex, step
	if reverse then
		startIndex, endIndex, step = #frames, 1, -1
	else
		startIndex, endIndex, step = 1, #frames, 1
	end

	local animationComplete = Instance.new("BindableEvent")
	local framesCompleted = 0

	for i = startIndex, endIndex, step do
		task.spawn(function()
			local frame = frames[i]
			task.wait(delay * math.abs(i - startIndex))

			Utilities.Tween(frame, {
				Goal = {
					Position = UDim2.new(
						frame.Position.X.Scale, 
						frame.Position.X.Offset, 
						positionOffsetY, 
						frame.Position.Y.Offset
					)
				},
				Duration = duration,
				EasingStyle = Enum.EasingStyle.Exponential,
				EasingDirection = Enum.EasingDirection.Out
			})

			Utilities.Tween(frame, {
				Goal = { BackgroundTransparency = transparencyGoal },
				Duration = transparencyDuration,
				EasingStyle = Enum.EasingStyle.Exponential,
				EasingDirection = Enum.EasingDirection.In,
				Callback = function()
					framesCompleted = framesCompleted + 1
					if framesCompleted >= #frames then
						animationComplete:Fire()
					end
				end
			})
		end)
	end

	return animationComplete.Event
end

local function IsInBounds(gui, point)
	local position = gui.AbsolutePosition
	local size = gui.AbsoluteSize
	return point.X >= position.X and point.X <= position.X + size.X and
		point.Y >= position.Y and point.Y <= position.Y + size.Y
end

Journe.Core.Notifications.Parent = Journe.Core.Main
Journe.Core.NotificationsPadding.Parent = Journe.Core.Notifications
Journe.Core.NotificationsLayout.Parent = Journe.Core.Notifications

function Journe:Notify(Settings)
	Settings = Utilities.Settings({
		Title = "Journe Demo",
		Description = "Baseplate - Test",
		Type = "Notification",
		Duration = 6
	}, Settings or {})

	local Notification = {}

	do
		Notification.Notification = Utilities.NewObject("Frame", {
			Parent = Journe.Core.Notifications,
			Name = "Notification",
			BorderSizePixel = 0,
			BackgroundColor3 = Journe.Themes[Journe.SelectedTheme].Background,
			AnchorPoint = Vector2.new(1, 0.5),
			Size = UDim2.new(0, 0, 0, 60),
			Position = UDim2.new(1.09487, 0, 0.99998, 0),
			BorderColor3 = Color3.fromRGB(0, 0, 0)
		})

		Notification.NotificationCorner = Utilities.NewObject("UICorner", {
			Parent = Notification.Notification,
			Name = "NotificationCorner",
			CornerRadius = UDim.new(0, 6)
		})

		Notification.Backdrop = Utilities.NewObject("Frame", {
			Parent = Notification.Notification,
			Name = "Backdrop",
			BorderSizePixel = 0,
			BackgroundColor3 = Journe.Themes[Journe.SelectedTheme].Group.Background,
			AnchorPoint = Vector2.new(0, 0.5),
			Size = UDim2.new(0, 40, 0, 40),
			Position = UDim2.new(0, 10, 0.5, 0),
			BorderColor3 = Color3.fromRGB(0, 0, 0)
		})

		Notification.BackdropCorner = Utilities.NewObject("UICorner", {
			Parent = Notification.Backdrop,
			Name = "BackdropCorner",
			CornerRadius = UDim.new(1, 0)
		})

		Notification.BackdropStroke = Utilities.NewObject("UIStroke", {
			Parent = Notification.Backdrop,
			Name = "BackdropStroke",
			ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
			Color = Journe.Themes[Journe.SelectedTheme].Seperators
		})

		Notification.Icon = Utilities.NewObject("ImageLabel", {
			Parent = Notification.Backdrop,
			Name = "Icon",
			BorderSizePixel = 0,
			BackgroundColor3 = Color3.fromRGB(255, 255, 255),
			ImageColor3 = Journe.Themes[Journe.SelectedTheme].Group.Items.ImageNText.Normal,
			AnchorPoint = Vector2.new(0.5, 0.5),
			Image = Settings.Type == "Notification" and "rbxassetid://118500495053779" or Settings.Type == "Warning" and "rbxassetid://123461891178438",
			Size = UDim2.new(0, 20, 0, 20),
			BorderColor3 = Color3.fromRGB(0, 0, 0),
			BackgroundTransparency = 1,
			Position = UDim2.new(0.5, 0, 0.5, 0)
		})

		Notification.Text = Utilities.NewObject("TextLabel", {
			Parent = Notification.Notification,
			Name = "Text",
			BorderSizePixel = 0,
			TextXAlignment = Enum.TextXAlignment.Left,
			TextYAlignment = Enum.TextYAlignment.Top,
			BackgroundColor3 = Color3.fromRGB(255, 255, 255),
			TextSize = 15,
			FontFace = Font.new("rbxassetid://11702779409", Enum.FontWeight.SemiBold, Enum.FontStyle.Normal),
			TextColor3 = Journe.Themes[Journe.SelectedTheme].ImageNText.Light,
			BackgroundTransparency = 1,
			AnchorPoint = Vector2.new(0, 0.5),
			Size = UDim2.new(1, 0, 1, 0),
			BorderColor3 = Color3.fromRGB(0, 0, 0),
			Text = Settings.Title,
			Position = UDim2.new(0, 50, 0.5, 0)
		})

		Notification.TextPadding = Utilities.NewObject("UIPadding", {
			Parent = Notification.Text,
			Name = "TextPadding",
			PaddingTop = UDim.new(0, 15),
			PaddingLeft = UDim.new(0, 10)
		})

		Notification.Description = Utilities.NewObject("TextLabel", {
			Parent = Notification.Text,
			Name = "Description",
			BorderSizePixel = 0,
			TextXAlignment = Enum.TextXAlignment.Left,
			TextYAlignment = Enum.TextYAlignment.Top,
			TextWrapped = true,
			BackgroundColor3 = Color3.fromRGB(255, 255, 255),
			TextSize = 10,
			FontFace = Font.new("rbxassetid://11702779409", Enum.FontWeight.Regular, Enum.FontStyle.Normal),
			TextColor3 = Journe.Themes[Journe.SelectedTheme].ImageNText.Dark,
			BackgroundTransparency = 1,
			Size = UDim2.new(1, 0, 0, 40),
			BorderColor3 = Color3.fromRGB(0, 0, 0),
			Text = Settings.Description
		})

		Notification.DescriptionPadding = Utilities.NewObject("UIPadding", {
			Parent = Notification.Description,
			Name = "DescriptionPadding",
			PaddingTop = UDim.new(0, 15),
			PaddingLeft = UDim.new(0, 1)
		})

		task.spawn(function()
			RunService.RenderStepped:Connect(function()
				Notification.Notification.Size = UDim2.new(0, Notification.Text.TextBounds.X + 80, 0, 60)
			end)
			task.wait(Settings.Duration)
			Utilities.Tween(Notification.Notification, {
				Goal = {Size = UDim2.new(0, 0, 0, 60)},
				Duration = 1,
				Callback = function()
					Notification.Notification:Destroy()
				end
			})
		end)
	end	

	return 	Notification
end

function Journe:CreateWindow(Settings)
	Settings = Utilities.Settings({
		Title = "Journe Demo",
		Description = "Baseplate",
		YouTubeLink = "https://www.youtube.com/@tekkit9070",
		DiscordLink = "https://discord.gg/CXFxhXShwt",
		Bind = "RightControl",
		Theme = "Light"
	}, Settings)

	Journe.SelectedTheme = Settings.Theme

	local Interface = {
		BoundKey = Settings.Bind,
		CurrentActiveTab = nil,
		CurrentPicker = nil,
		Animations = true,
		InputHandler = {
			Settings = {
				Hover = false
			},

			Bind = {
				Binding = false,
			}
		}
	}

	do
		-- Main
		do
			Interface.Core = Utilities.NewObject("Frame", {
				Parent = Journe.Core.Main,
				Name = "Core",
				BorderSizePixel = 0,
				BackgroundColor3 = Color3.fromRGB(255, 255, 255),
				AnchorPoint = Vector2.new(0.5, 0.5),
				Size = UserInputService.TouchEnabled and UDim2.new(0, 553, 0, 384) or UDim2.new(0, 679, 0, 526),
				Position = UDim2.new(0.5, 0, 0.5, 0),
				BorderColor3 = Color3.fromRGB(0, 0, 0),
				BackgroundTransparency = 1
			})

			Interface.Interface = Utilities.NewObject("Frame", {
				Parent = Interface.Core,
				Name = "Interface",
				BorderSizePixel = 0,
				BackgroundColor3 = Journe.Themes[Journe.SelectedTheme].Background,
				AnchorPoint = Vector2.new(0.5, 0.5),
				Size = UDim2.new(1, 0, 1, 0),
				Position = UDim2.new(0.5, 0, 0.5, 0),
				BorderColor3 = Color3.fromRGB(0, 0, 0)
			})

			Interface.BorderCorner = Utilities.NewObject("UICorner", {
				Parent = Interface.Interface,
				Name = "BorderCorner",
				CornerRadius = UDim.new(0, 6)
			})

			Interface.MainView = Utilities.NewObject("Frame", {
				Parent = Interface.Interface,
				Name = "MainView",
				BorderSizePixel = 0,
				BackgroundColor3 = Color3.fromRGB(255, 255, 255),
				Size = UDim2.new(1, 0, 1, 0),
				BorderColor3 = Color3.fromRGB(0, 0, 0),
				BackgroundTransparency = 1
			})

			Interface.Main = Utilities.NewObject("Frame", {
				Parent = Interface.MainView,
				Name = "Main",
				BorderSizePixel = 0,
				BackgroundColor3 = Color3.fromRGB(255, 255, 255),
				ClipsDescendants = true,
				Size = UDim2.new(1, -180, 1, -45),
				Position = UDim2.new(0, 180, 0, 45),
				BorderColor3 = Color3.fromRGB(0, 0, 0),
				BackgroundTransparency = 1
			})

			Interface.MainPadding = Utilities.NewObject("UIPadding", {
				Parent = Interface.Main,
				Name = "MainPadding",
				PaddingTop = UDim.new(0, 15),
				PaddingRight = UDim.new(0, 10),
				PaddingLeft = UDim.new(0, 10),
				PaddingBottom = UDim.new(0, 10)
			})

			Interface.Navigation = Utilities.NewObject("Frame", {
				Parent = Interface.MainView,
				Name = "Navigation",
				BorderSizePixel = 0,
				BackgroundColor3 = Color3.fromRGB(255, 255, 255),
				ClipsDescendants = true,
				Size = UDim2.new(0, 180, 1, 0),
				BorderColor3 = Color3.fromRGB(0, 0, 0),
				BackgroundTransparency = 1
			})

			Interface.Seperator = Utilities.NewObject("Frame", {
				Parent = Interface.Navigation,
				Name = "Seperator",
				BorderSizePixel = 0,
				BackgroundColor3 = Journe.Themes[Journe.SelectedTheme].Seperators,
				AnchorPoint = Vector2.new(1, 0),
				Size = UDim2.new(0, 2, 1, 0),
				Position = UDim2.new(1, 0, 0, 0),
				BorderColor3 = Color3.fromRGB(0, 0, 0)
			})

			Interface.Title = Utilities.NewObject("Frame", {
				Parent = Interface.Navigation,
				Name = "Title",
				BorderSizePixel = 0,
				BackgroundColor3 = Color3.fromRGB(255, 255, 255),
				Size = UDim2.new(1, 0, 0, 45),
				BorderColor3 = Color3.fromRGB(0, 0, 0),
				BackgroundTransparency = 1
			})

			Interface.Seperator = Utilities.NewObject("Frame", {
				Parent = Interface.Title,
				Name = "Seperator",
				BorderSizePixel = 0,
				BackgroundColor3 = Journe.Themes[Journe.SelectedTheme].Seperators,
				Size = UDim2.new(1, 0, 0, 2),
				Position = UDim2.new(0, 0, 1, 0),
				BorderColor3 = Color3.fromRGB(0, 0, 0)
			})

			Interface.Text = Utilities.NewObject("TextLabel", {
				Parent = Interface.Title,
				Name = "Text",
				BorderSizePixel = 0,
				TextXAlignment = Enum.TextXAlignment.Left,
				TextYAlignment = Enum.TextYAlignment.Top,
				BackgroundColor3 = Color3.fromRGB(255, 255, 255),
				TextSize = 15,
				FontFace = Font.new("rbxassetid://11702779409", Enum.FontWeight.SemiBold, Enum.FontStyle.Normal),
				TextColor3 = Journe.Themes[Journe.SelectedTheme].ImageNText.Light,
				BackgroundTransparency = 1,
				Size = UDim2.new(1, 0, 0, 40),
				BorderColor3 = Color3.fromRGB(0, 0, 0),
				Text = Settings.Title
			})

			Interface.TextPadding = Utilities.NewObject("UIPadding", {
				Parent = Interface.Text,
				Name = "TextPadding",
				PaddingTop = UDim.new(0, 12),
				PaddingLeft = UDim.new(0, 10)
			})

			Interface.Description = Utilities.NewObject("TextLabel", {
				Parent = Interface.Text,
				Name = "Description",
				BorderSizePixel = 0,
				TextXAlignment = Enum.TextXAlignment.Left,
				TextYAlignment = Enum.TextYAlignment.Top,
				BackgroundColor3 = Color3.fromRGB(255, 255, 255),
				TextSize = 10,
				FontFace = Font.new("rbxassetid://11702779409", Enum.FontWeight.Regular, Enum.FontStyle.Normal),
				TextColor3 = Journe.Themes[Journe.SelectedTheme].ImageNText.ReallyDark,
				BackgroundTransparency = 1,
				Size = UDim2.new(1, 0, 0, 40),
				BorderColor3 = Color3.fromRGB(0, 0, 0),
				Text = Settings.Description
			})

			Interface.DescriptionPadding = Utilities.NewObject("UIPadding", {
				Parent = Interface.Description,
				Name = "DescriptionPadding",
				PaddingTop = UDim.new(0, 15),
				PaddingLeft = UDim.new(0, 1)
			})

			Interface.Buttons = Utilities.NewObject("ScrollingFrame", {
				Parent = Interface.Navigation,
				Name = "Buttons",
				Active = true,
				BorderSizePixel = 0,
				BackgroundColor3 = Color3.fromRGB(255, 255, 255),
				Size = UDim2.new(1, 0, 1, -45),
				ScrollBarImageColor3 = Color3.fromRGB(109, 109, 109),
				Position = UDim2.new(0, 0, 0, 45),
				BorderColor3 = Color3.fromRGB(0, 0, 0),
				ScrollBarThickness = 0,
				BackgroundTransparency = 1
			})

			Interface.TopBar = Utilities.NewObject("Frame", {
				Parent = Interface.MainView,
				Name = "TopBar",
				BorderSizePixel = 0,
				BackgroundColor3 = Color3.fromRGB(255, 255, 255),
				Size = UDim2.new(1, -180, 0, 45),
				Position = UDim2.new(0, 180, 0, 0),
				BorderColor3 = Color3.fromRGB(0, 0, 0),
				BackgroundTransparency = 1
			})

			Interface.Seperator = Utilities.NewObject("Frame", {
				Parent = Interface.TopBar,
				Name = "Seperator",
				BorderSizePixel = 0,
				BackgroundColor3 = Journe.Themes[Journe.SelectedTheme].Seperators,
				Size = UDim2.new(1, 0, 0, 2),
				Position = UDim2.new(0, 0, 1, 0),
				BorderColor3 = Color3.fromRGB(0, 0, 0)
			})

			Interface.SettingsIcon = Utilities.NewObject("ImageLabel", {
				Parent = Interface.TopBar,
				Name = "Settings",
				BorderSizePixel = 0,
				BackgroundColor3 = Color3.fromRGB(255, 255, 255),
				ScaleType = Enum.ScaleType.Fit,
				ImageColor3 = Journe.Themes[Journe.SelectedTheme].ImageNText.Dark,
				Image = "rbxassetid://120427186698913",
				Size = UDim2.new(0, 14, 0, 14),
				BorderColor3 = Color3.fromRGB(0, 0, 0),
				BackgroundTransparency = 1,
				AnchorPoint = Vector2.new(1, 0.5),
				Position = UDim2.new(1, -15, 0.5, 0)
			})

			Interface.CurrentTab = Utilities.NewObject("TextLabel", {
				Parent = Interface.TopBar,
				Name = "CurrentTab",
				BorderSizePixel = 0,
				TextXAlignment = Enum.TextXAlignment.Left,
				BackgroundColor3 = Color3.fromRGB(255, 255, 255),
				TextSize = 14,
				FontFace = Font.new("rbxassetid://11702779409", Enum.FontWeight.SemiBold, Enum.FontStyle.Normal),
				TextColor3 = Journe.Themes[Journe.SelectedTheme].ImageNText.Dark,
				BackgroundTransparency = 1,
				Size = UDim2.new(1, 0, 1, 0),
				BorderColor3 = Color3.fromRGB(0, 0, 0),
				Text = "Preview"
			})

			Interface.CurrentTabPadding = Utilities.NewObject("UIPadding", {
				Parent = Interface.CurrentTab,
				Name = "CurrentTabPadding",
				PaddingTop = UDim.new(0, 1),
				PaddingLeft = UDim.new(0, 15)
			})
		end

		-- Settings
		do
			Interface.SettingsView = Utilities.NewObject("Frame", {
				Parent = Interface.Interface,
				Name = "SettingsView",
				Visible = false,
				BorderSizePixel = 0,
				BackgroundColor3 = Color3.fromRGB(16, 16, 16),
				AnchorPoint = Vector2.new(0.5, 0.5),
				Size = UDim2.new(1, 0, 1, 0),
				Position = UDim2.new(0.5, 0, 0.5, 0),
				BorderColor3 = Color3.fromRGB(0, 0, 0),
				BackgroundTransparency = 1
			})

			Interface.TopBarAlternate = Utilities.NewObject("Frame", {
				Parent = Interface.SettingsView,
				Name = "TopBarAlternate",
				BorderSizePixel = 0,
				BackgroundColor3 = Color3.fromRGB(255, 255, 255),
				Size = UDim2.new(1, 0, 0, 45),
				BorderColor3 = Color3.fromRGB(0, 0, 0),
				BackgroundTransparency = 1
			})

			Interface.SeperatorAlternate = Utilities.NewObject("Frame", {
				Parent = Interface.TopBarAlternate,
				Name = "SeperatorAlternate",
				BorderSizePixel = 0,
				BackgroundColor3 = Journe.Themes[Journe.SelectedTheme].Seperators,
				Size = UDim2.new(1, 0, 0, 2),
				Position = UDim2.new(0, 0, 1, 0),
				BorderColor3 = Color3.fromRGB(0, 0, 0)
			})

			Interface.SettingsIconAlternate = Utilities.NewObject("ImageLabel", {
				Parent = Interface.TopBarAlternate,
				Name = "SettingsIconAlternate",
				BorderSizePixel = 0,
				BackgroundColor3 = Color3.fromRGB(255, 255, 255),
				ScaleType = Enum.ScaleType.Fit,
				ImageColor3 = Journe.Themes[Journe.SelectedTheme].ImageNText.Dark,
				AnchorPoint = Vector2.new(1, 0.5),
				Image = "rbxassetid://120427186698913",
				Size = UDim2.new(0, 14, 0, 14),
				BorderColor3 = Color3.fromRGB(0, 0, 0),
				BackgroundTransparency = 1,
				Position = UDim2.new(1, -15, 0.5, 0)
			})

			Interface.CurrentTabAlternate = Utilities.NewObject("TextLabel", {
				Parent = Interface.TopBarAlternate,
				Name = "CurrentTabAlternate",
				BorderSizePixel = 0,
				TextXAlignment = Enum.TextXAlignment.Left,
				BackgroundColor3 = Color3.fromRGB(255, 255, 255),
				TextSize = 14,
				FontFace = Font.new("rbxassetid://11702779409", Enum.FontWeight.SemiBold, Enum.FontStyle.Normal),
				TextColor3 = Journe.Themes[Journe.SelectedTheme].ImageNText.Dark,
				BackgroundTransparency = 1,
				Size = UDim2.new(1, 0, 1, 0),
				BorderColor3 = Color3.fromRGB(0, 0, 0),
				Text = "Interface Settings"
			})

			Interface.CurrentTabPaddingAlternate = Utilities.NewObject("UIPadding", {
				Parent = Interface.CurrentTabAlternate,
				Name = "CurrentTabPaddingAlternate",
				PaddingTop = UDim.new(0, 1),
				PaddingLeft = UDim.new(0, 15)
			})

			Interface.MainAlternate = Utilities.NewObject("Frame", {
				Parent = Interface.SettingsView,
				Name = "MainAlternate",
				BorderSizePixel = 0,
				BackgroundColor3 = Color3.fromRGB(255, 255, 255),
				Size = UDim2.new(1, 0, 1, -45),
				Position = UDim2.new(0, 0, 0, 45),
				BorderColor3 = Color3.fromRGB(0, 0, 0),
				BackgroundTransparency = 1
			})

			Interface.GeneralAlternate = Utilities.NewObject("Frame", {
				Parent = Interface.MainAlternate,
				Name = "GeneralAlternate",
				BorderSizePixel = 0,
				BackgroundColor3 = Journe.Themes[Journe.SelectedTheme].Group.Background,
				Size = UDim2.new(0, 240, 0, 116),
				Position = UDim2.new(0, 20, 0, 30),
				BorderColor3 = Color3.fromRGB(0, 0, 0)
			})

			Interface.GroupCornerAlternate = Utilities.NewObject("UICorner", {
				Parent = Interface.GeneralAlternate,
				Name = "GroupCornerAlternate",

			})

			Interface.GroupStrokeAlternate = Utilities.NewObject("UIStroke", {
				Parent = Interface.GeneralAlternate,
				Name = "GroupStrokeAlternate",
				ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
				Color = Journe.Themes[Journe.SelectedTheme].Group.Items.Stroke.Normal
			})

			Interface.TitleAlternate = Utilities.NewObject("TextLabel", {
				Parent = Interface.GeneralAlternate,
				Name = "TitleAlternate",
				BorderSizePixel = 0,
				TextXAlignment = Enum.TextXAlignment.Left,
				BackgroundColor3 = Color3.fromRGB(255, 255, 255),
				TextSize = 14,
				FontFace = Font.new("rbxasset://fonts/families/Roboto.json", Enum.FontWeight.Bold, Enum.FontStyle.Normal),
				TextColor3 = Journe.Themes[Journe.SelectedTheme].Group.Title,
				BackgroundTransparency = 1,
				Size = UDim2.new(1, 0, 0, 25),
				BorderColor3 = Color3.fromRGB(0, 0, 0),
				Text = "General Settings",
				Position = UDim2.new(0, 0, 0, 5)
			})

			Interface.TitlePaddingAlternate = Utilities.NewObject("UIPadding", {
				Parent = Interface.TitleAlternate,
				Name = "TitlePaddingAlternate",
				PaddingLeft = UDim.new(0, 10)
			})

			Interface.ItemsAlternate = Utilities.NewObject("Frame", {
				Parent = Interface.GeneralAlternate,
				Name = "ItemsAlternate",
				BorderSizePixel = 0,
				BackgroundColor3 = Color3.fromRGB(255, 255, 255),
				Size = UDim2.new(1, -20, 1, -45),
				Position = UDim2.new(0, 10, 0, 35),
				BorderColor3 = Color3.fromRGB(0, 0, 0),
				BackgroundTransparency = 1
			})

			Interface.ToggleAlternate = Utilities.NewObject("TextLabel", {
				Parent = Interface.ItemsAlternate,
				Name = "ToggleAlternate",
				BorderSizePixel = 0,
				TextXAlignment = Enum.TextXAlignment.Left,
				BackgroundColor3 = Color3.fromRGB(255, 255, 255),
				TextSize = 12,
				FontFace = Font.new("rbxasset://fonts/families/Roboto.json", Enum.FontWeight.Medium, Enum.FontStyle.Normal),
				TextColor3 = Journe.Themes[Journe.SelectedTheme].Group.Items.ImageNText.Normal,
				BackgroundTransparency = 1,
				Size = UDim2.new(1, 0, 0, 30),
				BorderColor3 = Color3.fromRGB(0, 0, 0),
				Text = "Animations"
			})

			Interface.TogglePaddingAlternate = Utilities.NewObject("UIPadding", {
				Parent = Interface.ToggleAlternate,
				Name = "TogglePaddingAlternate",
				PaddingRight = UDim.new(0, 10),
				PaddingLeft = UDim.new(0, 10)
			})

			Interface.SwitchBackdropAlternate = Utilities.NewObject("Frame", {
				Parent = Interface.ToggleAlternate,
				Name = "StateAlternate",
				BorderSizePixel = 0,
				BackgroundColor3 = Journe.Themes[Journe.SelectedTheme].Group.Items.Toggle.ToggleBackground.Off,
				AnchorPoint = Vector2.new(1, 0.5),
				ClipsDescendants = true,
				Size = UDim2.new(0, 30, 0, 16),
				Position = UDim2.new(1, 0, 0.5, 0),
				BorderColor3 = Color3.fromRGB(0, 0, 0)
			})

			Interface.SwitchBackdropCornerAlternate = Utilities.NewObject("UICorner", {
				Parent = Interface.SwitchBackdropAlternate,
				Name = "StateCornerAlternate",
				CornerRadius = UDim.new(0, 10)
			})

			Interface.SwitchAlternate = Utilities.NewObject("Frame", {
				Parent = Interface.SwitchBackdropAlternate,
				Name = "ToggleAlternate",
				BorderSizePixel = 0,
				BackgroundColor3 = Journe.Themes[Journe.SelectedTheme].Group.Items.Toggle.Switch.Off,
				AnchorPoint = Vector2.new(0, 0.5),
				Size = UDim2.new(0, 10, 0, 10),
				Position = UDim2.new(0, 3, 0.5, 0),
				BorderColor3 = Color3.fromRGB(0, 0, 0)
			})

			Interface.SwitchCornerAlternate = Utilities.NewObject("UICorner", {
				Parent = Interface.SwitchAlternate,
				Name = "ToggleCornerAlternate",
				CornerRadius = UDim.new(0, 10)
			})

			Interface.KeyBindAlternate = Utilities.NewObject("TextLabel", {
				Parent = Interface.ItemsAlternate,
				Name = "KeyBindAlternate",
				BorderSizePixel = 0,
				TextXAlignment = Enum.TextXAlignment.Left,
				BackgroundColor3 = Color3.fromRGB(255, 255, 255),
				TextSize = 12,
				FontFace = Font.new("rbxasset://fonts/families/Roboto.json", Enum.FontWeight.Medium, Enum.FontStyle.Normal),
				TextColor3 = Journe.Themes[Journe.SelectedTheme].Group.Items.ImageNText.Normal,
				BackgroundTransparency = 1,
				Size = UDim2.new(1, 0, 0, 30),
				BorderColor3 = Color3.fromRGB(0, 0, 0),
				Text = "Open / Close",
				Position = UDim2.new(-0.02797, 0, 0.7, 0)
			})

			Interface.KeybindPaddingAlternate = Utilities.NewObject("UIPadding", {
				Parent = Interface.KeyBindAlternate,
				Name = "KeybindPaddingAlternate",
				PaddingRight = UDim.new(0, 10),
				PaddingLeft = UDim.new(0, 10)
			})

			Interface.BindAlternate = Utilities.NewObject("Frame", {
				Parent = Interface.KeyBindAlternate,
				Name = "BindAlternate",
				BorderSizePixel = 0,
				BackgroundColor3 = Journe.Themes[Journe.SelectedTheme].Group.Items.ExtraArea,
				AnchorPoint = Vector2.new(1, 0.5),
				Size = UDim2.new(0, 50, 0, 15),
				Position = UDim2.new(1, 0, 0.5, 0),
				BorderColor3 = Color3.fromRGB(0, 0, 0)
			})

			Interface.BindCornerAlternate = Utilities.NewObject("UICorner", {
				Parent = Interface.BindAlternate,
				Name = "BindCornerAlternate",
				CornerRadius = UDim.new(0, 4)
			})

			Interface.BindStrokeAlternate = Utilities.NewObject("UIStroke", {
				Parent = Interface.BindAlternate,
				Name = "BindStrokeAlternate",
				ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
				Color = Journe.Themes[Journe.SelectedTheme].Group.Items.Stroke.Normal
			})

			Interface.ValueAlternate = Utilities.NewObject("TextLabel", {
				Parent = Interface.BindAlternate,
				Name = "ValueAlternate",
				TextWrapped = true,
				BorderSizePixel = 0,
				BackgroundColor3 = Color3.fromRGB(255, 255, 255),
				TextSize = 10,
				FontFace = Font.new("rbxassetid://11702779409", Enum.FontWeight.Regular, Enum.FontStyle.Normal),
				TextColor3 = Journe.Themes[Journe.SelectedTheme].ImageNText.Light,
				BackgroundTransparency = 1,
				Size = UDim2.new(1, 0, 1, 0),
				BorderColor3 = Color3.fromRGB(0, 0, 0),
				Text = Interface.BoundKey
			})

			Interface.ItemsLayoutAlternate = Utilities.NewObject("UIListLayout", {
				Parent = Interface.ItemsAlternate,
				Name = "ItemsLayoutAlternate",
				HorizontalAlignment = Enum.HorizontalAlignment.Center,
				Padding = UDim.new(0, 10),
				SortOrder = Enum.SortOrder.LayoutOrder
			})

			Interface.ButtonsPadding = Utilities.NewObject("UIPadding", {
				Parent = Interface.Buttons,
				Name = "ButtonsPadding",
				PaddingTop = UDim.new(0, 15),
				PaddingLeft = UDim.new(0, 10)
			})

			Interface.ButtonsLayout = Utilities.NewObject("UIListLayout", {
				Parent = Interface.Buttons,
				Name = "ButtonsPadding",
				Padding = UDim.new(0, 10),
			})
		end

		-- Transition
		do
			Interface.Transition = Utilities.NewObject("CanvasGroup", {
				Parent = Interface.Core,
				Name = "Transition",
				ZIndex = 6942062,
				BorderSizePixel = 0,
				BackgroundColor3 = Color3.fromRGB(255, 255, 255),
				Size = UDim2.new(1, 0, 1, 0),
				BorderColor3 = Color3.fromRGB(0, 0, 0),
				BackgroundTransparency = 1
			})

			Interface.TransitionCorner = Utilities.NewObject("UICorner", {
				Parent = Interface.Transition,
				Name = "TransitionCorner",
				CornerRadius = UDim.new(0, 6)
			})

			for i = 1, 12 do
				local position = i == 1 and 0 or (i - 1) * 60

				Interface["TransitionGroup" .. i] = Utilities.NewObject("Frame", {
					Parent = Interface.Transition,
					Name = "TransitionGroup" .. i,
					BorderSizePixel = 0,
					BackgroundColor3 = Journe.Themes[Journe.SelectedTheme].Background,
					Size = UDim2.new(0, 60, 1, 0),
					Position = UDim2.new(0, position, 0, 0),
					BorderColor3 = Color3.fromRGB(0, 0, 0),
					LayoutOrder = 1,
					BackgroundTransparency = 1
				})

				Interface["FrameTop" .. i] = Utilities.NewObject("Frame", {
					Parent = Interface["TransitionGroup" .. i],
					Name = "FrameTop" .. i,
					ZIndex = 6942062,
					BorderSizePixel = 0,
					BackgroundColor3 = Journe.Themes[Journe.SelectedTheme].Background,
					Size = UDim2.new(0, 60, 0.5, 0),
					BorderColor3 = Color3.fromRGB(0, 0, 0)
				})

				Interface["FrameBottom" .. i] = Utilities.NewObject("Frame", {
					Parent = Interface["TransitionGroup" .. i],
					Name = "FrameBottom" .. i,
					ZIndex = 6942062,
					BorderSizePixel = 0,
					BackgroundColor3 = Journe.Themes[Journe.SelectedTheme].Background,
					Size = UDim2.new(0, 60, 0.5, 0),
					Position = UDim2.new(0, 0, 0.5, 0),
					BorderColor3 = Color3.fromRGB(0, 0, 0)
				})
			end

			Interface.framesTop = {}
			Interface.framesBottom = {}

			for i = 1, 12 do
				table.insert(Interface.framesTop, Interface["FrameTop" .. i])
				table.insert(Interface.framesBottom, Interface["FrameBottom" .. i])
			end
		end

		-- Actions
		do
			Interface.Actions = Utilities.NewObject("Frame", {
				Parent = Journe.Core.Main,
				Name = "Actions",
				BorderSizePixel = 0,
				BackgroundColor3 = Journe.Themes[Journe.SelectedTheme].Background,
				AnchorPoint = Vector2.new(1, 0.5),
				Size = UDim2.new(0, 30, 0, 120),
				Position = UDim2.new(1, -5, 0.5, 0),
				BorderColor3 = Color3.fromRGB(0, 0, 0)
			})

			Interface.ActionsCorner = Utilities.NewObject("UICorner", {
				Parent = Interface.Actions,
				Name = "Actions Corner",
				CornerRadius = UDim.new(0, 6)
			})

			Interface.Logo = Utilities.NewObject("ImageLabel", {
				Parent = Interface.Actions,
				Name = "Logo",
				BorderSizePixel = 0,
				BackgroundColor3 = Color3.fromRGB(255, 255, 255),
				AnchorPoint = Vector2.new(0.5, 0),
				Image = "rbxassetid://94070408305448",
				Size = UDim2.new(0, 20, 0, 20),
				BorderColor3 = Color3.fromRGB(0, 0, 0),
				BackgroundTransparency = 1,
				Position = UDim2.new(0.5, 0, 0, 5),
				ImageColor3 = Journe.Themes[Journe.SelectedTheme].ImageNText.Light
			})

			Interface.Seperator = Utilities.NewObject("Frame", {
				Parent = Interface.Actions,
				Name = "Seperator",
				BorderSizePixel = 0,
				BackgroundColor3 = Journe.Themes[Journe.SelectedTheme].Seperators,
				AnchorPoint = Vector2.new(0.5, 0),
				Size = UDim2.new(0, 20, 0, 2),
				Position = UDim2.new(0.5, 0, 0, 30),
				BorderColor3 = Color3.fromRGB(0, 0, 0)
			})

			Interface.Visibility = Utilities.NewObject("ImageLabel", {
				Parent = Interface.Actions,
				Name = "Visibility",
				BorderSizePixel = 0,
				BackgroundColor3 = Color3.fromRGB(255, 255, 255),
				ImageColor3 = Journe.Themes[Journe.SelectedTheme].ImageNText.Dark,
				AnchorPoint = Vector2.new(0.5, 0),
				Image = "rbxassetid://97376150985090",
				Size = UDim2.new(0, 20, 0, 20),
				BorderColor3 = Color3.fromRGB(0, 0, 0),
				BackgroundTransparency = 1,
				Position = UDim2.new(0.5, 0, 0, 35)
			})

			Interface.Discord = Utilities.NewObject("ImageLabel", {
				Parent = Interface.Actions,
				Name = "Discord",
				BorderSizePixel = 0,
				BackgroundColor3 = Color3.fromRGB(255, 255, 255),
				ImageColor3 = Journe.Themes[Journe.SelectedTheme].ImageNText.Dark,
				AnchorPoint = Vector2.new(0.5, 0),
				Image = "rbxassetid://140455737059613",
				Size = UDim2.new(0, 20, 0, 20),
				BorderColor3 = Color3.fromRGB(0, 0, 0),
				BackgroundTransparency = 1,
				Position = UDim2.new(0.5, 0, 0, 65)
			})

			Interface.Youtube = Utilities.NewObject("ImageLabel", {
				Parent = Interface.Actions,
				Name = "Youtube",
				BorderSizePixel = 0,
				BackgroundColor3 = Color3.fromRGB(255, 255, 255),
				ImageColor3 = Journe.Themes[Journe.SelectedTheme].ImageNText.Dark,
				AnchorPoint = Vector2.new(0.5, 0),
				Image = "rbxassetid://135830546995228",
				Size = UDim2.new(0, 20, 0, 20),
				BorderColor3 = Color3.fromRGB(0, 0, 0),
				BackgroundTransparency = 1,
				Position = UDim2.new(0.5, 0, 0, 95)
			})
		end

		-- Logic
		do
			-- Settings like real ones fr fr
			do
				if RunService:IsStudio() then
					Data = {
						Animations = true,
						BoundKey = "RightControl"
					}
					function SaveData()
					end
				else
					Data = isfile("Journe.json") and HttpService:JSONDecode(readfile("Journe.json")) or {}
					function SaveData()
						local dataToSave = {
							Animations = Interface.Animations,
							BoundKey = Interface.BoundKey
						}
						writefile("Journe.json", HttpService:JSONEncode(dataToSave))
					end

					while Interface.BoundKey ~= Data.BoundKey do
						Interface.BoundKey = Data.BoundKey
						Interface.ValueAlternate.Text = Data.BoundKey
					end
				end

				-- Bind
				do
					Interface.KeyBindAlternate.MouseEnter:Connect(function()
						if not Interface.InputHandler.Bind.Binding then
							Utilities.Tween(Interface.KeyBindAlternate, {
								Goal = {TextColor3 = Journe.Themes[Journe.SelectedTheme].Group.Items.ImageNText.Hover},
								Duration = 0.12
							})
							Utilities.Tween(Interface.BindStrokeAlternate, {
								Goal = {Color = Journe.Themes[Journe.SelectedTheme].Group.Items.Stroke.Hover},
								Duration = 0.12
							})
						end
					end)

					Interface.KeyBindAlternate.MouseLeave:Connect(function()
						if not Interface.InputHandler.Bind.Binding then
							Utilities.Tween(Interface.KeyBindAlternate, {
								Goal = {TextColor3 = Journe.Themes[Journe.SelectedTheme].Group.Items.ImageNText.Normal},
								Duration = 0.12
							})
							Utilities.Tween(Interface.BindStrokeAlternate, {
								Goal = {Color = Journe.Themes[Journe.SelectedTheme].Group.Items.Stroke.Normal},
								Duration = 0.12
							})
						end
					end)

					Interface.KeyBindAlternate.InputBegan:Connect(function(Input)
						if Interface.InputHandler.Bind.Binding then
							return
						end

						if Input.UserInputType == Enum.UserInputType.MouseButton1 or Input.UserInputType == Enum.UserInputType.Touch then
							Interface.InputHandler.Bind.Binding = true

							coroutine.wrap(function()
								local dots = ""
								while Interface.InputHandler.Bind.Binding do
									Interface.ValueAlternate.Text = dots
									dots = dots == "..." and "." or dots .. "."
									Utilities.Tween(Interface.KeyBindAlternate, {
										Goal = {TextColor3 = Journe.Themes[Journe.SelectedTheme].Group.Items.ImageNText.Hover},
										Duration = 0.12
									})
									Utilities.Tween(Interface.BindStrokeAlternate, {
										Goal = {Color = Journe.Themes[Journe.SelectedTheme].Group.Items.Stroke.Hover},
										Duration = 0.12
									})
									wait(0.5)
								end
							end)()

							UserInputService.InputBegan:Wait()

							AddConnection(UserInputService.InputBegan, function(input)
								if Interface.InputHandler.Bind.Binding == true and input.UserInputType == Enum.UserInputType.Keyboard then
									local keyName = input.KeyCode.Name

									Interface.ValueAlternate.Text = keyName
									Interface.BoundKey = keyName

									Utilities.Tween(Interface.KeyBindAlternate, {
										Goal = {TextColor3 = Journe.Themes[Journe.SelectedTheme].Group.Items.ImageNText.Normal},
										Duration = 0.12
									})
									Utilities.Tween(Interface.BindStrokeAlternate, {
										Goal = {Color = Journe.Themes[Journe.SelectedTheme].Group.Items.Stroke.Normal},
										Duration = 0.12
									})

									Interface.InputHandler.Bind.Binding = false
									SaveData()
								end
							end)
						end
					end)

					UserInputService.InputBegan:Connect(function(input)
						if Interface.InputHandler.Bind.Binding then
							return
						end

						if input.UserInputType == Enum.UserInputType.Keyboard then
							if Interface.BoundKey and input.KeyCode.Name == Interface.BoundKey then
								if Transitioning == true then
									return
								end

								if Interface.Animations then
									task.spawn(function()
										if Transitioning == true then
											return
										end

										Transitioning = true

										local showTop = Transition(Interface.framesTop, 0, 0, 0.6, 0.3, 0.1, ShouldReverse)
										local showBottom = Transition(Interface.framesBottom, 0.5, 0, 0.6, 0.3, 0.1, ShouldReverse)

										local connections = {}
										local completed = 0
										for _, event in ipairs({showTop, showBottom}) do
											table.insert(connections, event:Connect(function()
												completed = completed + 1
												if completed >= 2 then
													if Interface.CurrentPicker ~= nil then
														if Interface.Interface.Visible == true then
															Utilities.Tween(Interface.CurrentPicker, {
																Goal = {Position = UDim2.new(Interface.CurrentPicker.Position.X.Scale, Interface.CurrentPicker.Position.X.Offset - 135, Interface.CurrentPicker.Position.Y.Scale, Interface.CurrentPicker.Position.Y.Offset)},
																Duration = 0.6,
																EasingStyle = Enum.EasingStyle.Exponential,	
																EasingDirection = Enum.EasingDirection.In,
																Callback = function()
																	Interface.CurrentPicker.Visible = false
																end
															})
														else
															Utilities.Tween(Interface.CurrentPicker, {
																Goal = {Position = UDim2.new(Interface.CurrentPicker.Position.X.Scale, Interface.CurrentPicker.Position.X.Offset + 135, Interface.CurrentPicker.Position.Y.Scale, Interface.CurrentPicker.Position.Y.Offset)},
																EasingStyle = Enum.EasingStyle.Exponential,
																EasingDirection = Enum.EasingDirection.In,
																Duration = 0.6
															})
														end
													end

													Interface.Interface.Visible = not Interface.Interface.Visible

													for _, connection in ipairs(connections) do
														connection:Disconnect()
													end

													task.wait(0.05)

													if Interface.CurrentPicker ~= nil then
														if Interface.Interface.Visible == true then
															Interface.CurrentPicker.Visible = true
														end
													end

													Transition(Interface.framesTop, -0.5, 0, 0.6, 0.3, 0.1, not ShouldReverse)
													Transition(Interface.framesBottom, 1, 0, 0.6, 0.3, 0.1, not ShouldReverse)
												end
											end))
										end

										ShouldReverse = not ShouldReverse

										task.wait(3)
										Transitioning = false
									end)
								else
									Interface.Interface.Visible = not Interface.Interface.Visible
								end
							end
						end
					end)

					AddConnection(RunService.RenderStepped, function()
						Utilities.Tween(Interface.BindAlternate, {
							Goal = {Size = UDim2.new(0, Interface.ValueAlternate.TextBounds.X + 10, 0, 15)},
							Duration = 0.08
						})
					end)
				end

				-- Animations
				do
					local function SetState(State)
						if State == nil then
							Interface.Animations = not Interface.Animations
							SaveData()
						else
							Interface.Animations = State
						end

						if Interface.Animations then
							Utilities.Tween(Interface.SwitchAlternate, {
								Goal = {Position = UDim2.new(0, 17, 0.5, 0)},
								Duration = 0.12
							})
							Utilities.Tween(Interface.SwitchAlternate, {
								Goal = {BackgroundColor3 = Journe.Themes[Journe.SelectedTheme].Group.Items.Toggle.Switch.On},
								Duration = 0.12
							})
							Utilities.Tween(Interface.SwitchBackdropAlternate, {
								Goal = {BackgroundColor3 = Journe.Themes[Journe.SelectedTheme].Group.Items.Toggle.ToggleBackground.On},
								Duration = 0.12
							})
						else
							Utilities.Tween(Interface.SwitchAlternate, {
								Goal = {Position = UDim2.new(0, 3, 0.5, 0)},
								Duration = 0.12
							})
							Utilities.Tween(Interface.SwitchAlternate, {
								Goal = {BackgroundColor3 = Journe.Themes[Journe.SelectedTheme].Group.Items.Toggle.Switch.Off},
								Duration = 0.12
							})
							Utilities.Tween(Interface.SwitchBackdropAlternate, {
								Goal = {BackgroundColor3 = Journe.Themes[Journe.SelectedTheme].Group.Items.Toggle.ToggleBackground.Off},
								Duration = 0.12
							})
						end
					end

					Interface.ToggleAlternate.MouseEnter:Connect(function()
						Utilities.Tween(Interface.ToggleAlternate, {
							Goal = {TextColor3 = Journe.Themes[Journe.SelectedTheme].Group.Items.ImageNText.Hover},
							Duration = 0.12
						})
					end)

					Interface.ToggleAlternate.MouseLeave:Connect(function()
						Utilities.Tween(Interface.ToggleAlternate, {
							Goal = {TextColor3 = Journe.Themes[Journe.SelectedTheme].Group.Items.ImageNText.Normal},
							Duration = 0.12
						})
					end)

					Interface.ToggleAlternate.InputBegan:Connect(function(input)
						if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
							SetState()
						end
					end)

					SetState(Data.Animations)
				end
			end

			-- Settings
			do
				Interface.SettingsIconAlternate.MouseEnter:Connect(function()
					Interface.InputHandler.Settings.Hover = true
					Utilities.Tween(Interface.SettingsIconAlternate, {
						Goal = {ImageColor3 = Journe.Themes[Journe.SelectedTheme].ImageNText.Light},
						Duration = 0.12
					})
				end)

				Interface.SettingsIconAlternate.MouseLeave:Connect(function()
					Interface.InputHandler.Settings.Hover = false
					Utilities.Tween(Interface.SettingsIconAlternate, {
						Goal = {ImageColor3 = Journe.Themes[Journe.SelectedTheme].ImageNText.Dark},
						Duration = 0.12
					})
				end)

				Interface.SettingsIcon.MouseEnter:Connect(function()
					Interface.InputHandler.Settings.Hover = true
					Utilities.Tween(Interface.SettingsIcon, {
						Goal = {ImageColor3 = Journe.Themes[Journe.SelectedTheme].ImageNText.Light},
						Duration = 0.12
					})
				end)

				Interface.SettingsIcon.MouseLeave:Connect(function()
					Interface.InputHandler.Settings.Hover = false
					Utilities.Tween(Interface.SettingsIcon, {
						Goal = {ImageColor3 = Journe.Themes[Journe.SelectedTheme].ImageNText.Dark},
						Duration = 0.12
					})
				end)

				UserInputService.InputBegan:Connect(function(Input)
					if (Input.UserInputType == Enum.UserInputType.MouseButton1 or Input.UserInputType == Enum.UserInputType.Touch) and Interface.InputHandler.Settings.Hover then

						if Transitioning == true then
							return
						end

						if Interface.Animations then
							task.spawn(function()
								if Transitioning == true then
									return
								end

								Transitioning = true

								local showTop = Transition(Interface.framesTop, 0, 0, 0.6, 0.3, 0.1, ShouldReverse)
								local showBottom = Transition(Interface.framesBottom, 0.5, 0, 0.6, 0.3, 0.1, ShouldReverse)

								local completed = 0

								local connectionTop, connectionBottom

								connectionTop = AddConnection(showTop, function()
									completed = completed + 1
									if completed >= 2 then

										Interface.SettingsView.Visible = not Interface.SettingsView.Visible
										Interface.MainView.Visible = not Interface.MainView.Visible

										connectionTop:Disconnect()
										connectionBottom:Disconnect()

										task.wait(0.05)

										Transition(Interface.framesTop, -0.5, 0, 0.6, 0.3, 0.1, not ShouldReverse)
										Transition(Interface.framesBottom, 1, 0, 0.6, 0.3, 0.1, not ShouldReverse)
									end
								end)

								connectionBottom = AddConnection(showBottom, function()
									completed = completed + 1
									if completed >= 2 then

										Interface.SettingsView.Visible = not Interface.SettingsView.Visible
										Interface.MainView.Visible = not Interface.MainView.Visible

										connectionTop:Disconnect()
										connectionBottom:Disconnect()

										task.wait(0.05)

										Transition(Interface.framesTop, -0.5, 0, 0.6, 0.3, 0.1, not ShouldReverse)
										Transition(Interface.framesBottom, 1, 0, 0.6, 0.3, 0.1, not ShouldReverse)
									end
								end)

								ShouldReverse = not ShouldReverse
								task.wait(3)
								Transitioning = false
							end)
						else
							Interface.SettingsView.Visible = not Interface.SettingsView.Visible
							Interface.MainView.Visible = not Interface.MainView.Visible
						end
					end
				end)

				if Interface.Animations then
					task.spawn(function()
						Transitioning = true

						Transition(Interface.framesTop, -0.5, 0, 0.6, 0.3, 0, true)
						Transition(Interface.framesBottom, 1, 0, 0.6, 0.3, 0, true)

						ShouldReverse = not ShouldReverse
						task.wait(3)
						Transitioning = false
					end)
				else
					task.spawn(function()

						Transition(Interface.framesTop, -0.5, 0, 0, 0, 0, true)
						Transition(Interface.framesBottom, 1, 0, 0, 0, 0, true)

						ShouldReverse = not ShouldReverse
					end)
				end
			end

			-- Actions
			do
				local function onMouseEnter(icon)
					Utilities.Tween(icon, {
						Goal = {ImageColor3 = Journe.Themes[Journe.SelectedTheme].ImageNText.Light},
						Duration = 0.12
					})
				end

				local function onMouseLeave(icon)
					Utilities.Tween(icon, {
						Goal = {ImageColor3 = Journe.Themes[Journe.SelectedTheme].ImageNText.Dark},
						Duration = 0.12
					})
				end

				local function onInputBegan(icon, callback, input)
					if (input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch) then
						callback()
					end
				end

				local function onInputEnded(icon, callback, input)
					if (input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch) then
						callback()
					end
				end

				Interface.Visibility.MouseEnter:Connect(function() onMouseEnter(Interface.Visibility) end)
				Interface.Visibility.MouseLeave:Connect(function() onMouseLeave(Interface.Visibility) end)
				Interface.Visibility.InputBegan:Connect(function(input)
					onInputBegan(Interface.Visibility, function()
						if Transitioning == true then
							return
						end

						if Interface.Animations then
							task.spawn(function()
								if Transitioning == true then
									return
								end

								Transitioning = true

								local showTop = Transition(Interface.framesTop, 0, 0, 0.6, 0.3, 0.1, ShouldReverse)
								local showBottom = Transition(Interface.framesBottom, 0.5, 0, 0.6, 0.3, 0.1, ShouldReverse)

								local completed = 0

								AddConnection(showTop, function()
									completed = completed + 1
									if completed >= 2 then
										task.spawn(function()
											if Interface.CurrentPicker ~= nil then
												if Interface.Interface.Visible == true then
													Utilities.Tween(Interface.CurrentPicker, {
														Goal = {
															Position = UDim2.new(
																Interface.CurrentPicker.Position.X.Scale,
																Interface.CurrentPicker.Position.X.Offset - 135,
																Interface.CurrentPicker.Position.Y.Scale,
																Interface.CurrentPicker.Position.Y.Offset
															)
														},
														Duration = 0.6,
														Callback = function()
															Interface.CurrentPicker.Visible = false
														end
													})
												else
													Utilities.Tween(Interface.CurrentPicker, {
														Goal = {
															Position = UDim2.new(
																Interface.CurrentPicker.Position.X.Scale,
																Interface.CurrentPicker.Position.X.Offset + 135,
																Interface.CurrentPicker.Position.Y.Scale,
																Interface.CurrentPicker.Position.Y.Offset
															)
														},
														Duration = 0.6
													})
												end
											end

											Interface.Interface.Visible = not Interface.Interface.Visible

											task.wait(0.05)

											if Interface.CurrentPicker ~= nil then
												if Interface.Interface.Visible == true then
													Interface.CurrentPicker.Visible = true
												end
											end

											Transition(Interface.framesTop, -0.5, 0, 0.6, 0.3, 0.1, not ShouldReverse)
											Transition(Interface.framesBottom, 1, 0, 0.6, 0.3, 0.1, not ShouldReverse)
										end)
									end
								end)

								AddConnection(showBottom, function()
									completed = completed + 1
									if completed >= 2 then
										task.spawn(function()
											if Interface.CurrentPicker ~= nil then
												if Interface.Interface.Visible == true then
													Utilities.Tween(Interface.CurrentPicker, {
														Goal = {
															Position = UDim2.new(
																Interface.CurrentPicker.Position.X.Scale,
																Interface.CurrentPicker.Position.X.Offset - 135,
																Interface.CurrentPicker.Position.Y.Scale,
																Interface.CurrentPicker.Position.Y.Offset
															)
														},
														Duration = 0.6,
														Callback = function()
															Interface.CurrentPicker.Visible = false
														end
													})
												else
													Utilities.Tween(Interface.CurrentPicker, {
														Goal = {
															Position = UDim2.new(
																Interface.CurrentPicker.Position.X.Scale,
																Interface.CurrentPicker.Position.X.Offset + 135,
																Interface.CurrentPicker.Position.Y.Scale,
																Interface.CurrentPicker.Position.Y.Offset
															)
														},
														Duration = 0.6
													})
												end
											end

											Interface.Interface.Visible = not Interface.Interface.Visible

											task.wait(0.05)

											if Interface.CurrentPicker ~= nil then
												if Interface.Interface.Visible == true then
													Interface.CurrentPicker.Visible = true
												end
											end

											Transition(Interface.framesTop, -0.5, 0, 0.6, 0.3, 0.1, not ShouldReverse)
											Transition(Interface.framesBottom, 1, 0, 0.6, 0.3, 0.1, not ShouldReverse)
										end)
									end
								end)

								ShouldReverse = not ShouldReverse

								task.wait(3)
								Transitioning = false
							end)
						else
							task.spawn(function()
								local showTop = Transition(Interface.framesTop, 0, 0, 0, 0, 0, ShouldReverse)
								local showBottom = Transition(Interface.framesBottom, 0.5, 0, 0, 0, 0, ShouldReverse)

								local completed = 0

								AddConnection(showTop, function()
									completed = completed + 1
									if completed >= 2 then
										task.spawn(function()
											if Interface.CurrentPicker ~= nil then
												if Interface.Interface.Visible == true then
													Utilities.Tween(Interface.CurrentPicker, {
														Goal = {
															Position = UDim2.new(
																Interface.CurrentPicker.Position.X.Scale,
																Interface.CurrentPicker.Position.X.Offset - 135,
																Interface.CurrentPicker.Position.Y.Scale,
																Interface.CurrentPicker.Position.Y.Offset
															)
														},
														Duration = 0.6,
														Callback = function()
															Interface.CurrentPicker.Visible = false
														end
													})
												else
													Utilities.Tween(Interface.CurrentPicker, {
														Goal = {
															Position = UDim2.new(
																Interface.CurrentPicker.Position.X.Scale,
																Interface.CurrentPicker.Position.X.Offset + 135,
																Interface.CurrentPicker.Position.Y.Scale,
																Interface.CurrentPicker.Position.Y.Offset
															)
														},
														Duration = 0.6
													})
												end
											end

											Interface.Interface.Visible = not Interface.Interface.Visible

											task.wait(0.05)

											if Interface.CurrentPicker ~= nil then
												if Interface.Interface.Visible == true then
													Interface.CurrentPicker.Visible = true
												end
											end

											Transition(Interface.framesTop, -0.5, 0, 0, 0, 0, not ShouldReverse)
											Transition(Interface.framesBottom, 1, 0, 0, 0, 0, not ShouldReverse)
										end)
									end
								end)

								AddConnection(showBottom, function()
									completed = completed + 1
									if completed >= 2 then
										task.spawn(function()
											if Interface.CurrentPicker ~= nil then
												if Interface.Interface.Visible == true then
													Utilities.Tween(Interface.CurrentPicker, {
														Goal = {
															Position = UDim2.new(
																Interface.CurrentPicker.Position.X.Scale,
																Interface.CurrentPicker.Position.X.Offset - 135,
																Interface.CurrentPicker.Position.Y.Scale,
																Interface.CurrentPicker.Position.Y.Offset
															)
														},
														Duration = 0.6,
														Callback = function()
															Interface.CurrentPicker.Visible = false
														end
													})
												else
													Utilities.Tween(Interface.CurrentPicker, {
														Goal = {
															Position = UDim2.new(
																Interface.CurrentPicker.Position.X.Scale,
																Interface.CurrentPicker.Position.X.Offset + 135,
																Interface.CurrentPicker.Position.Y.Scale,
																Interface.CurrentPicker.Position.Y.Offset
															)
														},
														Duration = 0.6
													})
												end
											end

											Interface.Interface.Visible = not Interface.Interface.Visible

											task.wait(0.05)

											if Interface.CurrentPicker ~= nil then
												if Interface.Interface.Visible == true then
													Interface.CurrentPicker.Visible = true
												end
											end

											Transition(Interface.framesTop, -0.5, 0, 0, 0, 0, not ShouldReverse)
											Transition(Interface.framesBottom, 1, 0, 0, 0, 0, not ShouldReverse)
										end)
									end
								end)

								ShouldReverse = not ShouldReverse
							end)
						end
					end, input)
				end)
				Interface.Visibility.InputEnded:Connect(function(input)
					onInputEnded(Interface.Visibility, function() end, input)
				end)

				Interface.Discord.MouseEnter:Connect(function() onMouseEnter(Interface.Discord) end)
				Interface.Discord.MouseLeave:Connect(function() onMouseLeave(Interface.Discord) end)
				Interface.Discord.InputBegan:Connect(function(input)
					onInputBegan(Interface.Visibility, function()
						setclipboard(Settings.DiscordLink)
					end, input)
				end)
				Interface.Discord.InputEnded:Connect(function(input)
					onInputEnded(Interface.Visibility, function() end, input)
				end)

				Interface.Youtube.MouseEnter:Connect(function() onMouseEnter(Interface.Youtube) end)
				Interface.Youtube.MouseLeave:Connect(function() onMouseLeave(Interface.Youtube) end)
				Interface.Youtube.InputBegan:Connect(function(input)
					onInputBegan(Interface.Visibility, function()
						setclipboard(Settings.YouTubeLink)
					end, input)
				end)
				Interface.Youtube.InputEnded:Connect(function(input)
					onInputEnded(Interface.Visibility, function() end, input)
				end)
			end

			CreateCursor(Interface.Interface, 128944823463663)
			Dragify(Interface.Core, Interface.Interface)
		end

		-- Tab
		function Interface:CreateTab(Settings)
			Settings = Utilities.Settings({
				Title = "Demo",
				Callback = function() end
			}, Settings or {})

			local Tab = {
				Active = false,
				GroupIndex = 0
			}

			do
				Tab.TabBtn = Utilities.NewObject("Frame", {
					Parent = Interface.Buttons,
					Name = "TabBtn",
					BorderSizePixel = 0,
					BackgroundColor3 = Journe.Themes[Journe.SelectedTheme].Tabs.Background.Inactive,
					Size = UDim2.new(1, -10, 0, 30),
					BorderColor3 = Color3.fromRGB(0, 0, 0)
				})

				Tab.TabBtnStroke = Utilities.NewObject("UIStroke", {
					Parent = Tab.TabBtn,
					Name = "TabBtnStroke",
					ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
					Color = Journe.Themes[Journe.SelectedTheme].Tabs.Stroke.Inactive
				})

				Tab.TabBtnCorner = Utilities.NewObject("UICorner", {
					Parent = Tab.TabBtn,
					Name = "TabBtnCorner",

				})

				Tab.Textx = Utilities.NewObject("TextLabel", {
					Parent = Tab.TabBtn,
					Name = "Text",
					BorderSizePixel = 0,
					TextXAlignment = Enum.TextXAlignment.Left,
					BackgroundColor3 = Color3.fromRGB(255, 255, 255),
					TextSize = 14,
					FontFace = Font.new("rbxassetid://11702779409", Enum.FontWeight.SemiBold, Enum.FontStyle.Normal),
					TextColor3 = Journe.Themes[Journe.SelectedTheme].Tabs.Text,
					BackgroundTransparency = 1,
					Size = UDim2.new(1, 0, 1, 0),
					BorderColor3 = Color3.fromRGB(0, 0, 0),
					Text = Settings.Title
				})

				Tab.TextPadding = Utilities.NewObject("UIPadding", {
					Parent = Tab.Textx,
					Name = "TextPadding",
					PaddingTop = UDim.new(0, 1),
					PaddingLeft = UDim.new(0, 10)
				})

				Tab.Tab = Utilities.NewObject("Frame", {
					Parent = Interface.Main,
					Name = "Tab",
					BorderSizePixel = 0,
					BackgroundColor3 = Color3.fromRGB(255, 255, 255),
					Size = UDim2.new(1, 0, 1, 0),
					BorderColor3 = Color3.fromRGB(0, 0, 0),
					BackgroundTransparency = 1,
					Visible = false
				})

				Tab.Groups = Utilities.NewObject("ScrollingFrame", {
					Parent = Tab.Tab,
					Name = "Groups",
					Active = true,
					BorderSizePixel = 0,
					BackgroundColor3 = Color3.fromRGB(255, 255, 255),
					ClipsDescendants = false,
					Size = UDim2.new(1, 0, 1, 0),
					CanvasSize = UDim2.new(0, 0, 9999, 0),
					ScrollBarImageColor3 = Color3.fromRGB(0, 0, 0),
					BorderColor3 = Color3.fromRGB(0, 0, 0),
					ScrollBarThickness = 0,
					BackgroundTransparency = 1
				})

				-- Logic
				do
					function Tab:DeactivateTab()
						if Tab.Active then
							Tab.Active = false
							Utilities.Tween(Tab.TabBtnStroke, {
								Goal = {Color = Journe.Themes[Journe.SelectedTheme].Tabs.Stroke.Inactive},
								Duration = 0.1,
								EasingSyle = Enum.EasingStyle.Exponential,
								EasingDirection = Enum.EasingDirection.In
							})
							Utilities.Tween(Tab.TabBtn, {
								Goal = {BackgroundColor3 = Journe.Themes[Journe.SelectedTheme].Tabs.Background.Inactive},
								Duration = 0.1,
								EasingSyle = Enum.EasingStyle.Exponential,
								EasingDirection = Enum.EasingDirection.In
							})
							Tab.Tab.Visible = false
						end
					end

					function Tab:ActivateTab()
						if not Tab.Active then
							if Interface.CurrentActiveTab then
								Interface.CurrentActiveTab:DeactivateTab()
							end

							Interface.CurrentTab.Text = Tab.Textx.Text
							Tab.Active = true
							Utilities.Tween(Tab.TabBtnStroke, {
								Goal = {Color = Journe.Themes[Journe.SelectedTheme].Tabs.Stroke.HoverNActive},
								Duration = 0.1,
								EasingSyle = Enum.EasingStyle.Exponential,
								EasingDirection = Enum.EasingDirection.In
							})
							Utilities.Tween(Tab.TabBtn, {
								Goal = {BackgroundColor3 = Journe.Themes[Journe.SelectedTheme].Tabs.Background.HoverNActive},
								Duration = 0.1,
								EasingSyle = Enum.EasingStyle.Exponential,
								EasingDirection = Enum.EasingDirection.In
							})
							Tab.Tab.Visible = true
							Interface.CurrentActiveTab = Tab
						end
					end

					Tab.TabBtn.MouseEnter:Connect(function()
						if not Tab.Active then
							Utilities.Tween(Tab.TabBtnStroke, {
								Goal = {Color = Journe.Themes[Journe.SelectedTheme].Tabs.Stroke.HoverNActive},
								Duration = 0.1,
								EasingSyle = Enum.EasingStyle.Exponential,
								EasingDirection = Enum.EasingDirection.In
							})
						end
					end)

					Tab.TabBtn.MouseLeave:Connect(function()
						if not Tab.Active then
							Utilities.Tween(Tab.TabBtnStroke, {
								Goal = {Color = Journe.Themes[Journe.SelectedTheme].Tabs.Stroke.Inactive},
								Duration = 0.1,
								EasingSyle = Enum.EasingStyle.Exponential,
								EasingDirection = Enum.EasingDirection.In
							})
						end
					end)

					Tab.TabBtn.InputBegan:Connect(function(Input)
						if Input.UserInputType == Enum.UserInputType.MouseButton1 or Input.UserInputType == Enum.UserInputType.Touch then
							Tab:ActivateTab()
							Settings.Callback()
							Utilities.Tween(Tab.TabBtnStroke, {
								Goal = {Color = Journe.Themes[Journe.SelectedTheme].Tabs.Stroke.HoverNActive},
								Duration = 0.1,
								EasingSyle = Enum.EasingStyle.Exponential,
								EasingDirection = Enum.EasingDirection.In
							})
						end
					end)

					if Interface.CurrentActiveTab == nil then
						Tab:ActivateTab()
					end
				end

				-- Group
				function Tab:AddGroup(Settings)
					Settings = Utilities.Settings({
						Title = "Demo"
					}, Settings or {})

					local Group = {
						SpacingX = 10,
						SpacingY = 10,
						MaxColumns = 2,
						Width = UserInputService.TouchEnabled and 171 or 234
					}

					Tab.GroupIndex += 1

					do
						Group.Group = Utilities.NewObject("Frame", {
							Parent = Tab.Groups,
							Name = "Group",
							BorderSizePixel = 0,
							BackgroundColor3 = Journe.Themes[Journe.SelectedTheme].Group.Background,
							Size = UDim2.new(0.5, -5, 0, 455),
							Position = UDim2.new(0.5, 5, 0, 0),
							BorderColor3 = Color3.fromRGB(0, 0, 0)
						})

						Group.GroupCorner = Utilities.NewObject("UICorner", {
							Parent = Group.Group,
							Name = "GroupCorner",
						})

						Group.GroupStroke = Utilities.NewObject("UIStroke", {
							Parent = Group.Group,
							Name = "GroupStroke",
							ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
							Color = Journe.Themes[Journe.SelectedTheme].Group.Items.Stroke.Normal
						})

						Group.Title = Utilities.NewObject("TextLabel", {
							Parent = Group.Group,
							Name = "Title",
							BorderSizePixel = 0,
							TextXAlignment = Enum.TextXAlignment.Left,
							BackgroundColor3 = Color3.fromRGB(255, 255, 255),
							TextSize = 14,
							FontFace = Font.new("rbxasset://fonts/families/Roboto.json", Enum.FontWeight.Bold, Enum.FontStyle.Normal),
							TextColor3 = Journe.Themes[Journe.SelectedTheme].Group.Title,
							BackgroundTransparency = 1,
							Size = UDim2.new(1, 0, 0, 25),
							BorderColor3 = Color3.fromRGB(0, 0, 0),
							Text = Settings.Title,
							Position = UDim2.new(0, 0, 0, 5)
						})

						Group.TitlePadding = Utilities.NewObject("UIPadding", {
							Parent = Group.Title,
							Name = "TitlePadding",
							PaddingLeft = UDim.new(0, 10)
						})

						Group.Items = Utilities.NewObject("Frame", {
							Parent = Group.Group,
							Name = "Items",
							BorderSizePixel = 0,
							BackgroundColor3 = Color3.fromRGB(255, 255, 255),
							Size = UDim2.new(1, -20, 1, -45),
							Position = UDim2.new(0, 10, 0, 35),
							BorderColor3 = Color3.fromRGB(0, 0, 0),
							BackgroundTransparency = 1
						})

						Group.ItemsLayout = Utilities.NewObject("UIListLayout", {
							Parent = Group.Items,
							Name = "ItemsLayout",
							HorizontalAlignment = Enum.HorizontalAlignment.Center,
							Padding = UDim.new(0, 10),
							SortOrder = Enum.SortOrder.LayoutOrder
						})

						-- Logic
						do
							function Group:UpdatePosition()
								if Tab.GroupIndex % 2 == 0 then
									Group.Group.Position = UDim2.new(0, Group.Width + Group.SpacingX, 0, 0)
								else
									Group.Group.Position = UDim2.new(0, 0, 0, 0)
								end

								if Tab.GroupIndex > 2 then
									local prevGroupsInColumn = {}

									for i = 1, Tab.GroupIndex - 1 do
										local prevGroup = Tab.Groups:FindFirstChild("Group" .. i)
										if prevGroup and (i - 1) % 2 == (Tab.GroupIndex - 1) % 2 then
											table.insert(prevGroupsInColumn, prevGroup)
										end
									end

									local posY = 0
									for _, prevGroup in ipairs(prevGroupsInColumn) do
										posY = posY + prevGroup.Size.Y.Offset + Group.SpacingY
									end

									Group.Group.Position = UDim2.new(
										Group.Group.Position.X.Scale, 
										Group.Group.Position.X.Offset, 
										0, 
										posY
									)
								end

								Group.Group.Name = "Group" .. Tab.GroupIndex
							end

							function Group:UpdateSize()
								local Height = 40  -- Base height
								local Elements = 0

								-- Calculate total height based on element types
								for _, v in pairs(Group.Items:GetChildren()) do
									if v.Name == "Button" or v.Name == "Input" or 
										v.Name == "Slider" or v.Name == "Toggle" or 
										v.Name == "KeyBind" or v.Name == "Colorpicker" or 
										v.Name == "Dropdown" then
										Height = Height + 40
										Elements = Elements + 1
									end
								end

								-- Adjust group size (reduce height slightly if only one element)
								Group.Group.Size = UDim2.new(
									0, 
									Group.Width, 
									0, 
									Elements == 1 and Height - 10 or Height
								)

								-- Reposition all existing groups
								for i = 1, Tab.GroupIndex do
									local currentGroup = Tab.Groups:FindFirstChild("Group" .. i)
									if currentGroup then
										-- X positioning logic
										if i % 2 == 0 then
											currentGroup.Position = UDim2.new(0, Group.Width + Group.SpacingX, 0, 0)
										else
											currentGroup.Position = UDim2.new(0, 0, 0, 0)
										end

										-- Vertical positioning logic for groups beyond first two
										if i > 2 then
											local prevGroupsInColumn = {}

											-- Find previous groups in the same column
											for j = 1, i - 1 do
												local prevGroup = Tab.Groups:FindFirstChild("Group" .. j)
												if prevGroup and (j - 1) % 2 == (i - 1) % 2 then
													table.insert(prevGroupsInColumn, prevGroup)
												end
											end

											-- Calculate cumulative height
											local posY = 0
											for _, prevGroup in ipairs(prevGroupsInColumn) do
												posY = posY + prevGroup.Size.Y.Offset + Group.SpacingY
											end

											-- Update group's Y position
											currentGroup.Position = UDim2.new(
												currentGroup.Position.X.Scale, 
												currentGroup.Position.X.Offset, 
												0, 
												posY
											)
										end
									end
								end
							end

							Group:UpdateSize()
							Group:UpdatePosition()
						end

						-- Elements
						do
							function Group:AddButton(Settings)
								Settings = Utilities.Settings({
									Title = "Button",
									Callback = function() end
								}, Settings or {})

								local Button = {
									MouseDown = false
								}

								do
									Button.Button = Utilities.NewObject("TextLabel", {
										Parent = Group.Items,
										Name = "Button",
										BorderSizePixel = 0,
										TextXAlignment = Enum.TextXAlignment.Left,
										BackgroundColor3 = Color3.fromRGB(255, 255, 255),
										TextSize = 12,
										FontFace = Font.new("rbxasset://fonts/families/Roboto.json", Enum.FontWeight.Medium, Enum.FontStyle.Normal),
										TextColor3 = Journe.Themes[Journe.SelectedTheme].Group.Items.ImageNText.Normal,
										BackgroundTransparency = 1,
										Size = UDim2.new(1, 0, 0, 30),
										BorderColor3 = Color3.fromRGB(0, 0, 0),
										Text = Settings.Title
									})

									Button.ButtonPadding = Utilities.NewObject("UIPadding", {
										Parent = Button.Button,
										Name = "ButtonPadding",
										PaddingRight = UDim.new(0, 10),
										PaddingLeft = UDim.new(0, 10)
									})

									Button.Icon = Utilities.NewObject("ImageLabel", {
										Parent = Button.Button,
										Name = "Icon",
										BorderSizePixel = 0,
										BackgroundColor3 = Color3.fromRGB(255, 255, 255),
										ImageColor3 = Journe.Themes[Journe.SelectedTheme].Group.Items.ImageNText.Normal,
										AnchorPoint = Vector2.new(1, 0.5),
										Image = "rbxassetid://125293628617993",
										Size = UDim2.new(0, 12, 0, 12),
										BorderColor3 = Color3.fromRGB(0, 0, 0),
										BackgroundTransparency = 1,
										Position = UDim2.new(1, 0, 0.5, 0)
									})

									-- Logic
									do
										function Button:Settext(Text)
											Button.Button.Text = Text
											Settings.Title = Text
										end

										function Button:SetCallback(Function)
											Settings.Callback = Function
										end

										Button.Button.MouseEnter:Connect(function()
											Button.Hover = true
											Utilities.Tween(Button.Button, {
												Goal = {TextColor3 = Journe.Themes[Journe.SelectedTheme].Group.Items.ImageNText.Hover},
												Duration = 0.12
											})
											Utilities.Tween(Button.Icon, {
												Goal = {ImageColor3 = Journe.Themes[Journe.SelectedTheme].Group.Items.ImageNText.Hover},
												Duration = 0.12
											})
										end)

										Button.Button.MouseLeave:Connect(function()
											Button.Hover = false
											Utilities.Tween(Button.Button, {
												Goal = {TextColor3 = Journe.Themes[Journe.SelectedTheme].Group.Items.ImageNText.Normal},
												Duration = 0.12
											})
											Utilities.Tween(Button.Icon, {
												Goal = {ImageColor3 = Journe.Themes[Journe.SelectedTheme].Group.Items.ImageNText.Normal},
												Duration = 0.12
											})
										end)

										Button.Button.InputBegan:Connect(function(input)
											if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
												Button.MouseDown = true
												Settings.Callback()
											end
										end)

										Button.Button.InputEnded:Connect(function(input)
											if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
												Button.MouseDown = false
												if Button.Hover then
													Utilities.Tween(Button.Button, {
														Goal = {TextColor3 = Journe.Themes[Journe.SelectedTheme].Group.Items.ImageNText.Hover},
														Duration = 0.12
													})
													Utilities.Tween(Button.Icon, {
														Goal = {ImageColor3 = Journe.Themes[Journe.SelectedTheme].Group.Items.ImageNText.Hover},
														Duration = 0.12
													})
												else
													Utilities.Tween(Button.Button, {
														Goal = {TextColor3 = Journe.Themes[Journe.SelectedTheme].Group.Items.ImageNText.Normal},
														Duration = 0.12
													})
													Utilities.Tween(Button.Icon, {
														Goal = {ImageColor3 = Journe.Themes[Journe.SelectedTheme].Group.Items.ImageNText.Normal},
														Duration = 0.12
													})
												end
											end
										end)
									end
								end

								Group:UpdateSize()
								Journe.Elements[tostring(#Journe.Elements + 1) .. "Button"] = {Settings}
								return Button
							end

							function Group:AddInput(Settings)
								Settings = Utilities.Settings({
									Title = "Demo",
									Default = "Input",
									Callback = function(v) end
								}, Settings or {})

								local Input = {
									Typing = false,
									Empty = false,
									Text = Settings.Default
								}

								do
									Input.Input = Utilities.NewObject("TextLabel", {
										Parent = Group.Items,
										Name = "Input",
										BorderSizePixel = 0,
										TextXAlignment = Enum.TextXAlignment.Left,
										BackgroundColor3 = Color3.fromRGB(255, 255, 255),
										TextSize = 12,
										FontFace = Font.new("rbxasset://fonts/families/Roboto.json", Enum.FontWeight.Medium, Enum.FontStyle.Normal),
										TextColor3 = Journe.Themes[Journe.SelectedTheme].Group.Items.ImageNText.Normal,
										BackgroundTransparency = 1,
										Size = UDim2.new(1, 0, 0, 30),
										BorderColor3 = Color3.fromRGB(0, 0, 0),
										Text = Settings.Title
									})

									Input.InputPadding = Utilities.NewObject("UIPadding", {
										Parent = Input.Input,
										Name = "InputPadding",
										PaddingRight = UDim.new(0, 10),
										PaddingLeft = UDim.new(0, 10)
									})

									Input.InputArea = Utilities.NewObject("Frame", {
										Parent = Input.Input,
										Name = "InputArea",
										BorderSizePixel = 0,
										BackgroundColor3 = Journe.Themes[Journe.SelectedTheme].Group.Items.ExtraArea,
										AnchorPoint = Vector2.new(1, 0.5),
										ClipsDescendants = true,
										Size = UDim2.new(0, 65, 0, 15),
										Position = UDim2.new(1, 0, 0.5, 0),
										BorderColor3 = Color3.fromRGB(0, 0, 0)
									})

									Input.InputCorner = Utilities.NewObject("UICorner", {
										Parent = Input.InputArea,
										Name = "InputCorner",
										CornerRadius = UDim.new(0, 4)
									})

									Input.InputStroke = Utilities.NewObject("UIStroke", {
										Parent = Input.InputArea,
										Name = "InputStroke",
										ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
										Color = Journe.Themes[Journe.SelectedTheme].Group.Items.Stroke.Normal
									})

									Input.Output = Utilities.NewObject("TextLabel", {
										Parent = Input.InputArea,
										Name = "Output",
										TextWrapped = true,
										BorderSizePixel = 0,
										AnchorPoint = Vector2.new(0.5, 0.5),
										BackgroundColor3 = Color3.fromRGB(255, 255, 255),
										TextSize = 10,
										FontFace = Font.new("rbxassetid://11702779409", Enum.FontWeight.Regular, Enum.FontStyle.Normal),
										TextColor3 = Journe.Themes[Journe.SelectedTheme].ImageNText.Light,
										BackgroundTransparency = 1,
										Size = UDim2.new(1, -10, 1, 0),
										ClipsDescendants = true,
										BorderColor3 = Color3.fromRGB(0, 0, 0),
										Text = Settings.Default,
										Position = UDim2.new(0.5, 0, 0.5, 0)
									})

									Input.InputBox = Utilities.NewObject("TextBox", {
										Parent = Input.Input,
										Name = "Input",
										TextColor3 = Journe.Themes[Journe.SelectedTheme].ImageNText.Light,
										BorderSizePixel = 0,
										TextTransparency = 1,
										TextSize = 10,
										FontFace = Font.new("rbxassetid://11702779409", Enum.FontWeight.Regular, Enum.FontStyle.Normal),
										ClipsDescendants = true,
										Size = UDim2.new(1, 0, 1, 0),
										BorderColor3 = Color3.fromRGB(0, 0, 0),
										Text = Settings.Default,
										BackgroundTransparency = 1,
										ClearTextOnFocus = false
									})

									-- Logic
									do
										function Input:Update()
											local textSize = Input.Output.TextBounds.X
											local targetWidth = math.clamp(textSize + 20, 10, 150)

											Utilities.Tween(Input.InputArea, {
												Goal = {Size = UDim2.new(0, targetWidth, 0, 15)},
												Duration = 0.12
											})
										end

										function Input:GetInputField()
											return Input.Output.Text
										end

										function Input:SetInputField(Text)
											Input.Output.Text = Text
											Input.InputBox.Text = Text
											Input.Text = Text
											Input.Empty = false
											Input:Update(Text)
										end

										Input.Input.MouseEnter:Connect(function()
											if not Input.Typing then
												Utilities.Tween(Input.Input, {
													Goal = {TextColor3 = Journe.Themes[Journe.SelectedTheme].Group.Items.ImageNText.Hover},
													Duration = 0.12
												})
												Utilities.Tween(Input.InputStroke, {
													Goal = {Color = Journe.Themes[Journe.SelectedTheme].Group.Items.Stroke.Hover},
													Duration = 0.12
												})
											end
										end)

										Input.Input.MouseLeave:Connect(function()
											if not Input.Typing then
												Utilities.Tween(Input.Input, {
													Goal = {TextColor3 = Journe.Themes[Journe.SelectedTheme].Group.Items.ImageNText.Normal},
													Duration = 0.12
												})
												Utilities.Tween(Input.InputStroke, {
													Goal = {Color = Journe.Themes[Journe.SelectedTheme].Group.Items.Stroke.Normal},
													Duration = 0.12
												})
											end
										end)

										Input.Input.InputBegan:Connect(function(input)
											if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
												if Input.InputBox.Text == "..." or Input.InputBox.Text == ".." or Input.InputBox.Text == "." or Input.InputBox.Text == "" or Input.InputBox.Text == " " then
													if Input.Output.Text == "..." or Input.Output.Text == ".." or Input.Output.Text == "." or Input.Output.Text == "" or Input.Output.Text == " " then
														Input.Empty = true
													end
												end

												Input.Typing = true

												Input.InputBox:CaptureFocus()

												coroutine.wrap(function()
													local dots = ""
													while Input.Empty == true do
														dots = dots == "..." and "." or dots .. "."
														Input.Output.Text = dots
														Input.InputBox.Text = dots
														Input:Update()
														wait(0.5)
													end
												end)()
											end
										end)

										Input.Input.InputEnded:Connect(function(input)
											if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
												Input.Typing = false

												Input.InputBox:ReleaseFocus()

												if Input.Hover then
													Utilities.Tween(Input.Input, {
														Goal = {TextColor3 = Journe.Themes[Journe.SelectedTheme].Group.Items.ImageNText.Hover},
														Duration = 0.12
													})
													Utilities.Tween(Input.InputStroke, {
														Goal = {Color = Journe.Themes[Journe.SelectedTheme].Group.Items.Stroke.Hover},
														Duration = 0.12
													})
												else
													Utilities.Tween(Input.Input, {
														Goal = {TextColor3 = Journe.Themes[Journe.SelectedTheme].Group.Items.ImageNText.Normal},
														Duration = 0.12
													})
													Utilities.Tween(Input.InputStroke, {
														Goal = {Color = Journe.Themes[Journe.SelectedTheme].Group.Items.Stroke.Normal},
														Duration = 0.12
													})
												end
											end
										end)

										Input.InputBox:GetPropertyChangedSignal("Text"):Connect(function()
											local Text = Input.InputBox.Text
											Input:SetInputField(Text)
											coroutine.wrap(function()
												Utilities.Tween(Input.InputStroke, {
													Goal = {Color = Journe.Themes[Journe.SelectedTheme].Group.Items.Stroke.Hover},
													Duration = 0.12
												})
												task.wait(0.06)
												Utilities.Tween(Input.InputStroke, {
													Goal = {Color = Journe.Themes[Journe.SelectedTheme].Group.Items.Stroke.Normal},
													Duration = 0.12
												})											
											end)()
										end)

										Input.InputBox.FocusLost:Connect(function()
											Settings.Callback(Input.Output.Text)
											if Input.Hover then
												Utilities.Tween(Input.Input, {
													Goal = {TextColor3 = Journe.Themes[Journe.SelectedTheme].Group.Items.ImageNText.Hover},
													Duration = 0.12
												})
												Utilities.Tween(Input.InputStroke, {
													Goal = {Color = Journe.Themes[Journe.SelectedTheme].Group.Items.Stroke.Hover},
													Duration = 0.12
												})
											else
												Utilities.Tween(Input.Input, {
													Goal = {TextColor3 = Journe.Themes[Journe.SelectedTheme].Group.Items.ImageNText.Normal},
													Duration = 0.12
												})
												Utilities.Tween(Input.InputStroke, {
													Goal = {Color = Journe.Themes[Journe.SelectedTheme].Group.Items.Stroke.Normal},
													Duration = 0.12
												})
											end
										end)
										Input:Update()
									end
								end

								Group:UpdateSize()
								Journe.Elements[tostring(#Journe.Elements + 1) .. "Input"] = {Settings, Input.Text}
								return Input	
							end

							function Group:AddSlider(Settings)
								Settings = Utilities.Settings({
									Title = "Demo",
									Callback = function() end,
									Increment = 0.2,
									Default = 5,
									Max = 10,
									Min = 0
								}, Settings or {})

								local Slider = {
									ValueNum = Settings.Default,
									Dragging = false
								}

								do
									Slider.Slider = Utilities.NewObject("TextLabel", {
										Parent = Group.Items,
										Name = "Slider",
										BorderSizePixel = 0,
										TextXAlignment = Enum.TextXAlignment.Left,
										BackgroundColor3 = Color3.fromRGB(255, 255, 255),
										TextSize = 12,
										FontFace = Font.new("rbxasset://fonts/families/Roboto.json", Enum.FontWeight.Medium, Enum.FontStyle.Normal),
										TextColor3 = Journe.Themes[Journe.SelectedTheme].Group.Items.ImageNText.Normal,
										BackgroundTransparency = 1,
										Size = UDim2.new(1, 0, 0, 30),
										BorderColor3 = Color3.fromRGB(0, 0, 0),
										Text = Settings.Title
									})

									Slider.SliderPadding = Utilities.NewObject("UIPadding", {
										Parent = Slider.Slider,
										Name = "SliderPadding",
										PaddingRight = UDim.new(0, 10),
										PaddingLeft = UDim.new(0, 10)
									})

									Slider.Value = Utilities.NewObject("Frame", {
										Parent = Slider.Slider,
										Name = "Value",
										BorderSizePixel = 0,
										BackgroundColor3 = Journe.Themes[Journe.SelectedTheme].Group.Items.ExtraArea,
										AnchorPoint = Vector2.new(1, 0.5),
										ClipsDescendants = true,
										Size = UDim2.new(0, 40, 0, 15),
										Position = UDim2.new(1, 0, 0.5, 0),
										BorderColor3 = Color3.fromRGB(0, 0, 0)
									})

									Slider.ValueCorner = Utilities.NewObject("UICorner", {
										Parent = Slider.Value,
										Name = "ValueCorner",
										CornerRadius = UDim.new(0, 4)
									})

									Slider.ValueStroke = Utilities.NewObject("UIStroke", {
										Parent = Slider.Value,
										Name = "ValueStroke",
										ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
										Color = Journe.Themes[Journe.SelectedTheme].Group.Items.Stroke.Normal
									})

									Slider.ValueLabel = Utilities.NewObject("TextBox", {
										Parent = Slider.Value,
										Name = "Value",
										TextWrapped = true,
										BorderSizePixel = 0,
										BackgroundColor3 = Color3.fromRGB(255, 255, 255),
										AnchorPoint = Vector2.new(0.5, 0.5),
										TextSize = 10,
										FontFace = Font.new("rbxassetid://11702779409", Enum.FontWeight.Regular, Enum.FontStyle.Normal),
										TextColor3 = Journe.Themes[Journe.SelectedTheme].ImageNText.Light,
										BackgroundTransparency = 1,
										Size = UDim2.new(1, 0, 1, 0),
										Position = UDim2.new(0.5, 0, 0.5, 0),
										BorderColor3 = Color3.fromRGB(0, 0, 0),
										Text = tostring(Settings.Default),
										ClearTextOnFocus = false
									})

									Slider.Main = Utilities.NewObject("Frame", {
										Parent = Slider.Slider,
										Name = "Slider",
										BorderSizePixel = 0,
										BackgroundColor3 = Journe.Themes[Journe.SelectedTheme].Group.Items.Slider.SliderBackground,
										AnchorPoint = Vector2.new(1, 0.5),
										Size = UDim2.new(1, -79, 0, 2),
										Position = UDim2.new(1, -45, 0.5, 0),
										BorderColor3 = Color3.fromRGB(0, 0, 0)
									})

									Slider.Circle = Utilities.NewObject("Frame", {
										Parent = Slider.Main,
										Name = "Circle",
										BorderSizePixel = 0,
										BackgroundColor3 = Journe.Themes[Journe.SelectedTheme].Group.Items.Slider.SliderBackground,
										AnchorPoint = Vector2.new(0.5, 0.5),
										Size = UDim2.new(0, 7, 0, 7),
										Position = UDim2.new(0, 0, 0.5, 0),
										BorderColor3 = Color3.fromRGB(0, 0, 0)
									})

									Slider.CircleCorner = Utilities.NewObject("UICorner", {
										Parent = Slider.Circle,
										Name = "CircleCorner",
										CornerRadius = UDim.new(1, 0)
									})

									-- Logic
									do
										function Slider:Update()
											local valueWidth = Slider.Value.AbsoluteSize.X
											Slider.Main.Size = UDim2.new(1, -(valueWidth + Slider.Slider.TextBounds.X + 20), 0, 2)
											Slider.Main.Position = UDim2.new(1, -(valueWidth + 10), 0.5, 0)

											local newSize = UDim2.new(0, math.min(Slider.ValueLabel.TextBounds.X + 10, 90), 0, 15)
											Slider.Value.Size = newSize

											local mainSize = Slider.Main.AbsoluteSize.X
											local circleSize = Slider.Circle.AbsoluteSize.X
											local maxOffset = mainSize - circleSize + 5
											local percent = (Slider.ValueNum - Settings.Min) / (Settings.Max - Settings.Min)
											local pixelOffset = percent * maxOffset
											Slider.Circle.Position = UDim2.new(0, pixelOffset, 0.5, 0)
										end

										function Slider:UpdateFromMouse(InputPos)
											local mainSize = Slider.Main.AbsoluteSize.X
											local circleSize = Slider.Circle.AbsoluteSize.X
											local maxOffset = mainSize - circleSize
											local relativeX = InputPos.X - Slider.Main.AbsolutePosition.X - (circleSize / 2)
											relativeX = math.clamp(relativeX, 0, maxOffset)
											local percent = relativeX / maxOffset
											local value = Settings.Min + (Settings.Max - Settings.Min) * percent
											Slider:SetValue(value)
										end

										local function ValidateTextValue(Text)
											Text = Text:gsub("[^%d%.]-", "")
											local decimalCount = 0
											Text = Text:gsub("%.", function()
												decimalCount = decimalCount + 1
												return decimalCount == 1 and "." or ""
											end)
											local num = tonumber(Text)
											if not num then return nil end
											return math.clamp(num, Settings.Min, Settings.Max)
										end

										function Slider:SetValue(value)
											local steps = math.floor((value - Settings.Min) / Settings.Increment + 0.5)
											value = Settings.Min + (steps * Settings.Increment)
											value = math.clamp(value, Settings.Min, Settings.Max)
											value = tonumber(string.format("%.10f", value))
											Slider.ValueNum = value
											Slider:Update()
											if not Slider.Editing then
												Slider.ValueLabel.Text = tostring(value)
											end
											Settings.Callback(value)
										end

										Slider.ValueLabel.Focused:Connect(function()
											Slider.Editing = true
										end)

										Slider.ValueLabel.FocusLost:Connect(function(enterPressed)
											Slider.Editing = false
											Slider.ValueLabel.TextColor3 = Color3.fromRGB(136, 136, 136)

											local newValue = ValidateTextValue(Slider.ValueLabel.Text)
											if newValue then
												Slider:SetValue(newValue)
											else
												Slider.ValueLabel.Text = tostring(Slider.ValueNum) 
											end
										end)

										Slider.ValueLabel.Changed:Connect(function(property)
											if property == "Text" and Slider.Editing then
												local text = Slider.ValueLabel.Text

												if text == "" then return end

												local cleaned = text:gsub("[^%d%.]-", "")

												Utilities.Tween(Slider.Slider, {
													Goal = {TextColor3 = Journe.Themes[Journe.SelectedTheme].Group.Items.ImageNText.Hover},
													Duration = 0.12
												})
												Utilities.Tween(Slider.ValueStroke, {
													Goal = {Color = Journe.Themes[Journe.SelectedTheme].Group.Items.Stroke.Hover},
													Duration = 0.12
												})
												if cleaned ~= text then
													Slider.ValueLabel.Text = cleaned

													Utilities.Tween(Slider.Slider, {
														Goal = {TextColor3 = Journe.Themes[Journe.SelectedTheme].Group.Items.ImageNText.Normal},
														Duration = 0.12
													})
													Utilities.Tween(Slider.ValueStroke, {
														Goal = {Color = Journe.Themes[Journe.SelectedTheme].Group.Items.Stroke.Normal},
														Duration = 0.12
													})
												end
											end
										end)

										Slider.Slider.MouseEnter:Connect(function()
											Utilities.Tween(Slider.Slider, {
												Goal = {TextColor3 = Journe.Themes[Journe.SelectedTheme].Group.Items.ImageNText.Hover},
												Duration = 0.12
											})
											Utilities.Tween(Slider.ValueStroke, {
												Goal = {Color = Journe.Themes[Journe.SelectedTheme].Group.Items.Stroke.Hover},
												Duration = 0.12
											})
										end)

										Slider.Slider.MouseLeave:Connect(function()
											Utilities.Tween(Slider.Slider, {
												Goal = {TextColor3 = Journe.Themes[Journe.SelectedTheme].Group.Items.ImageNText.Normal},
												Duration = 0.12
											})
											Utilities.Tween(Slider.ValueStroke, {
												Goal = {Color = Journe.Themes[Journe.SelectedTheme].Group.Items.Stroke.Normal},
												Duration = 0.12
											})
										end)

										Slider.Main.InputBegan:Connect(function(input)
											if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
												DisableDragging = true
												Slider.Dragging = true
												Slider:UpdateFromMouse(input.Position)

												Utilities.Tween(Slider.Slider, {
													Goal = {TextColor3 = Journe.Themes[Journe.SelectedTheme].Group.Items.ImageNText.Hover},
													Duration = 0.12
												})
												Utilities.Tween(Slider.ValueStroke, {
													Goal = {Color = Journe.Themes[Journe.SelectedTheme].Group.Items.Stroke.Hover},
													Duration = 0.12
												})
											end
										end)

										Slider.Slider.InputChanged:Connect(function(input)
											if Slider.Dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
												DisableDragging = true
												Slider:UpdateFromMouse(input.Position)

												Utilities.Tween(Slider.Slider, {
													Goal = {TextColor3 = Journe.Themes[Journe.SelectedTheme].Group.Items.ImageNText.Hover},
													Duration = 0.12
												})
												Utilities.Tween(Slider.ValueStroke, {
													Goal = {Color = Journe.Themes[Journe.SelectedTheme].Group.Items.Stroke.Hover},
													Duration = 0.12
												})
											end
										end)

										Slider.Slider.InputEnded:Connect(function(input)
											if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
												Slider.Dragging = false

												if Slider.Hover then
													Utilities.Tween(Slider.Slider, {
														Goal = {TextColor3 = Journe.Themes[Journe.SelectedTheme].Group.Items.ImageNText.Hover},
														Duration = 0.12
													})
													Utilities.Tween(Slider.ValueStroke, {
														Goal = {Color = Journe.Themes[Journe.SelectedTheme].Group.Items.Stroke.Hover},
														Duration = 0.12
													})
												else
													Utilities.Tween(Slider.Slider, {
														Goal = {TextColor3 = Journe.Themes[Journe.SelectedTheme].Group.Items.ImageNText.Normal},
														Duration = 0.12
													})
													Utilities.Tween(Slider.ValueStroke, {
														Goal = {Color = Journe.Themes[Journe.SelectedTheme].Group.Items.Stroke.Normal},
														Duration = 0.12
													})
												end
												DisableDragging = false
											end
										end)

										RunService.RenderStepped:Connect(function()
											Slider:Update()
										end)

										Slider:SetValue(Settings.Default)
										Slider:Update()
									end
								end

								Group:UpdateSize()
								Journe.Elements[tostring(#Journe.Elements + 1) .. "Slider"] = {Settings, Slider.ValueNum}
								return Slider
							end

							function Group:AddToggle(Settings)
								Settings = Utilities.Settings({
									Title = "Demo",
									Default = false,
									Callback = function(v) print(v) end
								}, Settings or {})

								local Toggle = {
									State = Settings.Default
								}

								do
									Toggle.Toggle = Utilities.NewObject("TextLabel", {
										Parent = Group.Items,
										Name = "Toggle",
										BorderSizePixel = 0,
										TextXAlignment = Enum.TextXAlignment.Left,
										BackgroundColor3 = Color3.fromRGB(255, 255, 255),
										TextSize = 12,
										FontFace = Font.new("rbxasset://fonts/families/Roboto.json", Enum.FontWeight.Medium, Enum.FontStyle.Normal),
										TextColor3 = Journe.Themes[Journe.SelectedTheme].Group.Items.ImageNText.Normal,
										BackgroundTransparency = 1,
										Size = UDim2.new(1, 0, 0, 30),
										BorderColor3 = Color3.fromRGB(0, 0, 0),
										Text = Settings.Title
									})

									Toggle.TogglePadding = Utilities.NewObject("UIPadding", {
										Parent = Toggle.Toggle,
										Name = "TogglePadding",
										PaddingRight = UDim.new(0, 10),
										PaddingLeft = UDim.new(0, 10)
									})

									Toggle.SwitchBackdrop = Utilities.NewObject("Frame", {
										Parent = Toggle.Toggle,
										Name = "State",
										BorderSizePixel = 0,
										BackgroundColor3 = Journe.Themes[Journe.SelectedTheme].Group.Items.Toggle.ToggleBackground.Off,
										AnchorPoint = Vector2.new(1, 0.5),
										ClipsDescendants = true,
										Size = UDim2.new(0, 30, 0, 16),
										Position = UDim2.new(1, 0, 0.5, 0),
										BorderColor3 = Color3.fromRGB(0, 0, 0)
									})

									Toggle.StateCorner = Utilities.NewObject("UICorner", {
										Parent = Toggle.SwitchBackdrop,
										Name = "StateCorner",
										CornerRadius = UDim.new(0, 10)
									})

									Toggle.Switch = Utilities.NewObject("Frame", {
										Parent = Toggle.SwitchBackdrop,
										Name = "Switch",
										BorderSizePixel = 0,
										BackgroundColor3 = Journe.Themes[Journe.SelectedTheme].Group.Items.Toggle.Switch.Off,
										AnchorPoint = Vector2.new(0, 0.5),
										Size = UDim2.new(0, 10, 0, 10),
										Position = UDim2.new(0, 3, 0.5, 0),
										BorderColor3 = Color3.fromRGB(0, 0, 0)
									})

									Toggle.SwitchCorner = Utilities.NewObject("UICorner", {
										Parent = Toggle.Switch,
										Name = "SwitchCorner",
										CornerRadius = UDim.new(0, 10)
									})

									do
										function Toggle:Settext(Text)
											Toggle.Toggle.Text = Text
											Settings.Title = Text
										end

										function Toggle:SetCallback(Function)
											Settings.Callback = Function
										end

										function Toggle:SetState(State)
											if State == nil then
												Toggle.State = not Toggle.State
											else
												Toggle.State = State
											end

											if Toggle.State then
												Utilities.Tween(Toggle.Switch, {
													Goal = {Position = UDim2.new(0, 17, 0.5, 0)},
													Duration = 0.12
												})
												Utilities.Tween(Toggle.Switch, {
													Goal = {BackgroundColor3 = Journe.Themes[Journe.SelectedTheme].Group.Items.Toggle.Switch.On},
													Duration = 0.12
												})
												Utilities.Tween(Toggle.SwitchBackdrop, {
													Goal = {BackgroundColor3 = Journe.Themes[Journe.SelectedTheme].Group.Items.Toggle.ToggleBackground.On},
													Duration = 0.12
												})
											else
												Utilities.Tween(Toggle.Switch, {
													Goal = {Position = UDim2.new(0, 3, 0.5, 0)},
													Duration = 0.12
												})
												Utilities.Tween(Toggle.Switch, {
													Goal = {BackgroundColor3 = Journe.Themes[Journe.SelectedTheme].Group.Items.Toggle.Switch.Off},
													Duration = 0.12
												})
												Utilities.Tween(Toggle.SwitchBackdrop, {
													Goal = {BackgroundColor3 = Journe.Themes[Journe.SelectedTheme].Group.Items.Toggle.ToggleBackground.Off},
													Duration = 0.12
												})
											end

											Settings.Callback(Toggle.State)	
										end

										Toggle.Toggle.MouseEnter:Connect(function()
											Utilities.Tween(Toggle.Toggle, {
												Goal = {TextColor3 = Journe.Themes[Journe.SelectedTheme].Group.Items.ImageNText.Hover},
												Duration = 0.12
											})
										end)

										Toggle.Toggle.MouseLeave:Connect(function()
											Utilities.Tween(Toggle.Toggle, {
												Goal = {TextColor3 = Journe.Themes[Journe.SelectedTheme].Group.Items.ImageNText.Normal},
												Duration = 0.12
											})
										end)

										Toggle.Toggle.InputBegan:Connect(function(input)
											if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
												Toggle:SetState()
											end
										end)

										Toggle.Toggle.InputEnded:Connect(function(input)
											if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
												if Toggle.Hover then
													Utilities.Tween(Toggle.Toggle, {
														Goal = {TextColor3 = Journe.Themes[Journe.SelectedTheme].Group.Items.ImageNText.Hover},
														Duration = 0.12
													})
												else
													Utilities.Tween(Toggle.Toggle, {
														Goal = {TextColor3 = Journe.Themes[Journe.SelectedTheme].Group.Items.ImageNText.Normal},
														Duration = 0.12
													})
												end
											end
										end)

										Toggle:SetState(Settings.Default)
									end
								end

								Group:UpdateSize()
								Journe.Elements[tostring(#Journe.Elements + 1) .. "Toggle"] = {Settings, Toggle.State}
								return Toggle
							end

							function Group:AddKeybind(Settings)
								Settings = Utilities.Settings({
									Title = "Demo",
									Default = "Z",
									Callback = function() end
								}, Settings or {})

								local Keybind = {
									Binding = false,
									Key = Settings.Default
								}

								do
									Keybind.KeyBind = Utilities.NewObject("TextLabel", {
										Parent = Group.Items,
										Name = "KeyBind",
										BorderSizePixel = 0,
										TextXAlignment = Enum.TextXAlignment.Left,
										BackgroundColor3 = Color3.fromRGB(255, 255, 255),
										TextSize = 12,
										FontFace = Font.new("rbxasset://fonts/families/Roboto.json", Enum.FontWeight.Medium, Enum.FontStyle.Normal),
										TextColor3 = Journe.Themes[Journe.SelectedTheme].Group.Items.ImageNText.Normal,
										BackgroundTransparency = 1,
										Size = UDim2.new(1, 0, 0, 30),
										BorderColor3 = Color3.fromRGB(0, 0, 0),
										Text = Settings.Title,
										Position = UDim2.new(-0.02797, 0, 0.7, 0)
									})

									Keybind.KeybindPadding = Utilities.NewObject("UIPadding", {
										Parent = Keybind.KeyBind,
										Name = "KeybindPadding",
										PaddingRight = UDim.new(0, 10),
										PaddingLeft = UDim.new(0, 10)
									})

									Keybind.Bind = Utilities.NewObject("Frame", {
										Parent = Keybind.KeyBind,
										Name = "Bind",
										BorderSizePixel = 0,
										BackgroundColor3 = Journe.Themes[Journe.SelectedTheme].Group.Items.ExtraArea,
										AnchorPoint = Vector2.new(1, 0.5),
										ClipsDescendants = true,
										Size = UDim2.new(0, 20, 0, 15),
										Position = UDim2.new(1, 0, 0.5, 0),
										BorderColor3 = Color3.fromRGB(0, 0, 0)
									})

									Keybind.BindCorner = Utilities.NewObject("UICorner", {
										Parent = Keybind.Bind,
										Name = "BindCorner",
										CornerRadius = UDim.new(0, 4)
									})

									Keybind.BindStroke = Utilities.NewObject("UIStroke", {
										Parent = Keybind.Bind,
										Name = "BindStroke",
										ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
										Color = Journe.Themes[Journe.SelectedTheme].Group.Items.Stroke.Normal
									})

									Keybind.Value = Utilities.NewObject("TextLabel", {
										Parent = Keybind.Bind,
										Name = "Value",
										TextWrapped = true,
										BorderSizePixel = 0,
										BackgroundColor3 = Color3.fromRGB(255, 255, 255),
										TextSize = 10,
										FontFace = Font.new("rbxassetid://11702779409", Enum.FontWeight.Regular, Enum.FontStyle.Normal),
										TextColor3 = Journe.Themes[Journe.SelectedTheme].ImageNText.Light,
										BackgroundTransparency = 1,
										Size = UDim2.new(1, 0, 1, 0),
										ClipsDescendants = true,
										BorderColor3 = Color3.fromRGB(0, 0, 0),
										Text = Settings.Default
									})

									Keybind.Input = Utilities.NewObject("TextBox", {
										Parent = Keybind.Bind,
										Name = "Input",
										TextColor3 = Color3.fromRGB(0, 0, 0),
										BorderSizePixel = 0,
										TextWrapped = true,
										TextTransparency = 1,
										TextSize = 14,
										TextScaled = true,
										BackgroundColor3 = Color3.fromRGB(255, 255, 255),
										FontFace = Font.new("rbxasset://fonts/families/SourceSansPro.json", Enum.FontWeight.Regular, Enum.FontStyle.Normal),
										ClipsDescendants = true,
										Size = UDim2.new(1, 0, 1, 0),
										BorderColor3 = Color3.fromRGB(0, 0, 0),
										Text = "",
										BackgroundTransparency = 1
									})

									do
										function Keybind:Setkey(Key)
											Keybind.Binding = false
											Keybind.Value.Text = Key
											Keybind.Key = Key
										end

										Keybind.KeyBind.MouseEnter:Connect(function()
											Utilities.Tween(Keybind.KeyBind, {
												Goal = {TextColor3 = Journe.Themes[Journe.SelectedTheme].Group.Items.ImageNText.Hover},
												Duration = 0.12
											})
											Utilities.Tween(Keybind.BindStroke, {
												Goal = {Color = Journe.Themes[Journe.SelectedTheme].Group.Items.Stroke.Hover},
												Duration = 0.12
											})
										end)

										Keybind.KeyBind.MouseLeave:Connect(function()
											Utilities.Tween(Keybind.KeyBind, {
												Goal = {TextColor3 = Journe.Themes[Journe.SelectedTheme].Group.Items.ImageNText.Normal},
												Duration = 0.12
											})
											Utilities.Tween(Keybind.BindStroke, {
												Goal = {Color = Journe.Themes[Journe.SelectedTheme].Group.Items.Stroke.Normal},
												Duration = 0.12
											})
										end)

										Keybind.KeyBind.InputBegan:Connect(function(Input)
											if Keybind.Binding then
												return
											end

											if Input.UserInputType == Enum.UserInputType.MouseButton1 or Input.UserInputType == Enum.UserInputType.Touch then
												Keybind.Binding = true

												coroutine.wrap(function()
													local dots = ""
													while Keybind.Binding do
														Keybind.Value.Text = dots
														dots = dots == "..." and "." or dots .. "."
														wait(0.5)
													end
												end)()

												UserInputService.InputBegan:Wait()

												AddConnection(UserInputService.InputBegan, function(input)
													if Keybind.Binding == true and input.UserInputType == Enum.UserInputType.Keyboard then
														local Key = input.KeyCode.Name

														Keybind:Setkey(Key)

														RunService.RenderStepped:Connect(function()
															Utilities.Tween(Keybind.Bind, {
																Goal = {Size = UDim2.new(0, Keybind.Value.TextBounds.X + 10, 0, 15)},
																Duration = 0.08
															})
														end)
													end
												end)

												Keybind.KeyBind.InputEnded:Connect(function(input)
													if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
														if Keybind.Hover then
															Utilities.Tween(Keybind.KeyBind, {
																Goal = {TextColor3 = Journe.Themes[Journe.SelectedTheme].Group.Items.ImageNText.Hover},
																Duration = 0.12
															})
															Utilities.Tween(Keybind.BindStroke, {
																Goal = {Color = Journe.Themes[Journe.SelectedTheme].Group.Items.Stroke.Hover},
																Duration = 0.12
															})
														else
															Utilities.Tween(Keybind.KeyBind, {
																Goal = {TextColor3 = Journe.Themes[Journe.SelectedTheme].Group.Items.ImageNText.Normal},
																Duration = 0.12
															})
															Utilities.Tween(Keybind.BindStroke, {
																Goal = {Color = Journe.Themes[Journe.SelectedTheme].Group.Items.Stroke.Normal},
																Duration = 0.12
															})
														end
													end
												end)
											end
										end)

										Keybind:Setkey(Settings.Default)
									end
								end

								Group:UpdateSize()
								Journe.Elements[tostring(#Journe.Elements + 1) .. "Keybind"] = {Settings, Keybind.Key}
								return Keybind
							end	

							function Group:AddColorpicker(Settings)
								Settings = Utilities.Settings({
									Title = "Demo",
									Default = {
										Color = Color3.fromRGB(255, 255, 255),
										Alpha = 100
									},
									Callback = function(Color, Alpha) end
								}, Settings or {})

								local Colorpicker = {
									ColorVal = Settings.Default.Color,
									AlphaVal = Settings.Default.Alpha,
									InteractingMain = false,
									InteractingHue = false,
									InteractingAlpha = false
								}

								do
									Colorpicker.Colorpicker = Utilities.NewObject("TextLabel", {
										Parent = Group.Items,
										Name = "Colorpicker",
										BorderSizePixel = 0,
										TextXAlignment = Enum.TextXAlignment.Left,
										BackgroundColor3 = Color3.fromRGB(255, 255, 255),
										TextSize = 12,
										FontFace = Font.new("rbxasset://fonts/families/Roboto.json", Enum.FontWeight.Medium, Enum.FontStyle.Normal),
										TextColor3 = Journe.Themes[Journe.SelectedTheme].Group.Items.ImageNText.Normal,
										BackgroundTransparency = 1,
										Size = UDim2.new(1, 0, 0, 30),
										BorderColor3 = Color3.fromRGB(0, 0, 0),
										Text = Settings.Title,
										Position = UDim2.new(-0.02797, 0, 0.87391, 0)
									})

									Colorpicker.ColorpickerPadding = Utilities.NewObject("UIPadding", {
										Parent = Colorpicker.Colorpicker,
										Name = "ColorpickerPadding",
										PaddingRight = UDim.new(0, 10),
										PaddingLeft = UDim.new(0, 10)
									})

									Colorpicker.Preview = Utilities.NewObject("Frame", {
										Parent = Colorpicker.Colorpicker,
										Name = "Preview",
										BorderSizePixel = 0,
										BackgroundColor3 = Color3.fromRGB(255, 0, 0),
										AnchorPoint = Vector2.new(1, 0.5),
										Size = UDim2.new(0, 15, 0, 15),
										Position = UDim2.new(1, 0, 0.5, 0),
										BorderColor3 = Color3.fromRGB(0, 0, 0)
									})

									Colorpicker.PreviewCorner = Utilities.NewObject("UICorner", {
										Parent = Colorpicker.Preview,
										Name = "PreviewCorner",
										CornerRadius = UDim.new(0, 4)
									})

									Colorpicker.PreviewStroke = Utilities.NewObject("UIStroke", {
										Parent = Colorpicker.Preview,
										Name = "PreviewStroke",
										ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
										Color = Journe.Themes[Journe.SelectedTheme].Group.Items.Stroke.Normal
									})

									Colorpicker.Picker = Utilities.NewObject("CanvasGroup", {
										Parent = Interface.Core,
										Name = "Picker",
										BorderSizePixel = 0,
										BackgroundColor3 = Journe.Themes[Journe.SelectedTheme].Group.Background,
										AnchorPoint = Vector2.new(1, 0),
										Size = UDim2.new(0, 125, 0, 160),
										Position = UDim2.new(1, 130, 0, 0),
										BorderColor3 = Color3.fromRGB(0, 0, 0),
										Visible = false
									})

									Colorpicker.Main = Utilities.NewObject("Frame", {
										Parent = Colorpicker.Picker,
										Name = "Main",
										BorderSizePixel = 0,
										BackgroundColor3 = Color3.fromRGB(255, 0, 0),
										Size = UDim2.new(0, 115, 0, 83),
										Position = UDim2.new(0, 5, 0, 5),
										BorderColor3 = Color3.fromRGB(0, 0, 0)
									})

									Colorpicker.Overlay = Utilities.NewObject("ImageLabel", {
										Parent = Colorpicker.Main,
										Name = "Overlay",
										BorderSizePixel = 0,
										BackgroundColor3 = Color3.fromRGB(255, 255, 255),
										Image = "rbxassetid://137209735553764",
										Size = UDim2.new(1, 0, 1, 0),
										BorderColor3 = Color3.fromRGB(0, 0, 0),
										BackgroundTransparency = 1
									})

									Colorpicker.BorderCorner = Utilities.NewObject("UICorner", {
										Parent = Colorpicker.Overlay,
										Name = "BorderCorner",
										CornerRadius = UDim.new(0, 3)
									})

									Colorpicker.Cursor = Utilities.NewObject("ImageLabel", {
										Parent = Colorpicker.Main,
										Name = "Cursor",
										BorderSizePixel = 0,
										BackgroundColor3 = Color3.fromRGB(255, 255, 255),
										ImageColor3 = Color3.fromRGB(255, 0, 0),
										AnchorPoint = Vector2.new(0.5, 0.5),
										Image = "rbxassetid://138369252414915",
										Size = UDim2.new(0, 12, 0, 12),
										BorderColor3 = Color3.fromRGB(0, 0, 0),
										BackgroundTransparency = 1,
										Position = UDim2.new(0, 150, 0, -5)
									})

									Colorpicker.BorderCorner = Utilities.NewObject("UICorner", {
										Parent = Colorpicker.Main,
										Name = "BorderCorner",
										CornerRadius = UDim.new(0, 3)
									})

									Colorpicker.BorderCorner = Utilities.NewObject("UICorner", {
										Parent = Colorpicker.Picker,
										Name = "BorderCorner",
										CornerRadius = UDim.new(0, 6)
									})

									Colorpicker.Hue = Utilities.NewObject("Frame", {
										Parent = Colorpicker.Picker,
										Name = "Hue",
										BorderSizePixel = 0,
										BackgroundColor3 = Color3.fromRGB(255, 255, 255),
										Size = UDim2.new(1, -10, 0, 8),
										Position = UDim2.new(0, 5, 0, 99),
										BorderColor3 = Color3.fromRGB(0, 0, 0)
									})

									Colorpicker.HueCorner = Utilities.NewObject("UICorner", {
										Parent = Colorpicker.Hue,
										Name = "HueCorner",
										CornerRadius = UDim.new(0, 6)
									})

									Colorpicker.HueGradient = Utilities.NewObject("UIGradient", {
										Parent = Colorpicker.Hue,
										Name = "HueGradient",
										Color = ColorSequence.new{ColorSequenceKeypoint.new(0.000, Color3.fromRGB(255, 0, 0)),ColorSequenceKeypoint.new(0.125, Color3.fromRGB(255, 139, 0)),ColorSequenceKeypoint.new(0.250, Color3.fromRGB(255, 231, 0)),ColorSequenceKeypoint.new(0.375, Color3.fromRGB(21, 255, 0)),ColorSequenceKeypoint.new(0.500, Color3.fromRGB(0, 164, 255)),ColorSequenceKeypoint.new(0.625, Color3.fromRGB(6, 0, 255)),ColorSequenceKeypoint.new(0.750, Color3.fromRGB(174, 0, 255)),ColorSequenceKeypoint.new(0.875, Color3.fromRGB(255, 0, 200)),ColorSequenceKeypoint.new(1.000, Color3.fromRGB(255, 0, 0))}
									})

									Colorpicker.AlphaPicker = Utilities.NewObject("Frame", {
										Parent = Colorpicker.Picker,
										Name = "Alpha",
										BorderSizePixel = 0,
										BackgroundColor3 = Color3.fromRGB(255, 255, 255),
										Size = UDim2.new(1, -10, 0, 8),
										Position = UDim2.new(0, 5, 0, 115),
										BorderColor3 = Color3.fromRGB(0, 0, 0)
									})

									Colorpicker.AlphaBorder = Utilities.NewObject("UICorner", {
										Parent = Colorpicker.AlphaPicker,
										Name = "AlphaBorder",
										CornerRadius = UDim.new(0, 6)
									})

									Colorpicker.AlphaGradient = Utilities.NewObject("UIGradient", {
										Parent = Colorpicker.AlphaPicker,
										Name = "AlphaGradient",
										Transparency = NumberSequence.new{NumberSequenceKeypoint.new(0.000, 1),NumberSequenceKeypoint.new(1.000, 0)}
									})

									Colorpicker.Hex = Utilities.NewObject("Frame", {
										Parent = Colorpicker.Picker,
										Name = "Hex",
										BorderSizePixel = 0,
										BackgroundColor3 = Color3.fromRGB(255, 255, 255),
										Size = UDim2.new(1, -10, 0, 28),
										Position = UDim2.new(0, 5, 0, 131),
										BorderColor3 = Color3.fromRGB(0, 0, 0),
										BackgroundTransparency = 1
									})

									Colorpicker.CodeArea = Utilities.NewObject("Frame", {
										Parent = Colorpicker.Hex,
										Name = "CodeArea",
										BorderSizePixel = 0,
										BackgroundColor3 = Journe.Themes[Journe.SelectedTheme].Group.Items.ExtraArea,
										ClipsDescendants = true,
										Size = UDim2.new(0, 64, 0, 20),
										BorderColor3 = Color3.fromRGB(0, 0, 0)
									})

									Colorpicker.CodeAreaCorner = Utilities.NewObject("UICorner", {
										Parent = Colorpicker.CodeArea,
										Name = "CodeAreaCorner",
										CornerRadius = UDim.new(0, 4)
									})

									Colorpicker.CodeAreaStroke = Utilities.NewObject("UIStroke", {
										Parent = Colorpicker.CodeArea,
										Name = "CodeAreaStroke",
										ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
										Color = Journe.Themes[Journe.SelectedTheme].Group.Items.Stroke.Normal
									})

									Colorpicker.HexCode = Utilities.NewObject("TextLabel", {
										Parent = Colorpicker.CodeArea,
										Name = "HexCode",
										TextWrapped = true,
										BorderSizePixel = 0,
										BackgroundColor3 = Color3.fromRGB(255, 255, 255),
										TextSize = 14,
										FontFace = Font.new("rbxassetid://11702779409", Enum.FontWeight.Regular, Enum.FontStyle.Normal),
										TextColor3 = Color3.fromRGB(136, 136, 136),
										BackgroundTransparency = 1,
										RichText = true,
										AnchorPoint = Vector2.new(0.5, 0.5),
										Size = UDim2.new(0, 58, 0, 15),
										ClipsDescendants = true,
										BorderColor3 = Color3.fromRGB(0, 0, 0),
										Text = [[<font color="#9CA3AF">#</font><font color="#374151">FFFFFF</font>]],
										Position = UDim2.new(0.5, 0, 0.5, 0)
									})

									Colorpicker.HexCodePadding = Utilities.NewObject("UIPadding", {
										Parent = Colorpicker.HexCode,
										Name = "HexCodePadding",
										PaddingLeft = UDim.new(0, 5)
									})

									Colorpicker.AplhaArea = Utilities.NewObject("Frame", {
										Parent = Colorpicker.Hex,
										Name = "CodeArea",
										BorderSizePixel = 0,
										BackgroundColor3 = Journe.Themes[Journe.SelectedTheme].Group.Items.ExtraArea,
										ClipsDescendants = true,
										Size = UDim2.new(0, 39, 0, 20),
										Position = UDim2.new(0, 74, 0, 0),
										BorderColor3 = Color3.fromRGB(0, 0, 0)
									})

									Colorpicker.AlphaAreaCorner = Utilities.NewObject("UICorner", {
										Parent = Colorpicker.AplhaArea,
										Name = "CodeAreaCorner",
										CornerRadius = UDim.new(0, 4)
									})

									Colorpicker.AlphaAreaStroke = Utilities.NewObject("UIStroke", {
										Parent = Colorpicker.AplhaArea,
										Name = "CodeAreaStroke",
										ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
										Color = Journe.Themes[Journe.SelectedTheme].Group.Items.Stroke.Normal
									})

									Colorpicker.AlphaValue = Utilities.NewObject("TextLabel", {
										Parent = Colorpicker.AplhaArea,
										Name = "AlphaValue",
										TextWrapped = true,
										BorderSizePixel = 0,
										BackgroundColor3 = Color3.fromRGB(255, 255, 255),
										TextSize = 16,
										FontFace = Font.new("rbxassetid://11702779409", Enum.FontWeight.Regular, Enum.FontStyle.Normal),
										TextColor3 = Color3.fromRGB(136, 136, 136),
										BackgroundTransparency = 1,
										RichText = true,
										AnchorPoint = Vector2.new(0.5, 0.5),
										Size = UDim2.new(1, 0, 0, 15),
										ClipsDescendants = true,
										BorderColor3 = Color3.fromRGB(0, 0, 0),
										Text = "100%",
										Position = UDim2.new(0.5, 0, 0.5, 0)
									})

									Colorpicker.AlphaValuePadding = Utilities.NewObject("UIPadding", {
										Parent = Colorpicker.AplhaValue,
										Name = "AlphaValuePadding",
										PaddingLeft = UDim.new(0, 5)
									})

									do
										Colorpicker.Colorpicker.MouseEnter:Connect(function()
											Utilities.Tween(Colorpicker.Colorpicker, {
												Goal = {TextColor3 = Journe.Themes[Journe.SelectedTheme].Group.Items.ImageNText.Hover},
												Duration = 0.12
											})
										end)

										Colorpicker.Colorpicker.MouseLeave:Connect(function()
											Utilities.Tween(Colorpicker.Colorpicker, {
												Goal = {TextColor3 = Journe.Themes[Journe.SelectedTheme].Group.Items.ImageNText.Normal},
												Duration = 0.12
											})
										end)

										Colorpicker.Colorpicker.InputBegan:Connect(function(Input)
											if Input.UserInputType == Enum.UserInputType.MouseButton1 or Input.UserInputType == Enum.UserInputType.Touch then
												if Interface.CurrentPicker ~= nil then
													Colorpicker.Picker.Visible = not Colorpicker.Picker.Visible
													Interface.CurrentPicker.Visible = not Interface.CurrentPicker.Visible
													Interface.CurrentPicker = Colorpicker.Picker
												else
													Colorpicker.Picker.Visible = not Colorpicker.Picker.Visible
													Interface.CurrentPicker = Colorpicker.Picker
												end
											end
										end)

										Colorpicker.Colorpicker.InputEnded:Connect(function(input)
											if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
												if Colorpicker.Hover then
													Utilities.Tween(Colorpicker.Colorpicker, {
														Goal = {TextColor3 = Journe.Themes[Journe.SelectedTheme].Group.Items.ImageNText.Hover},
														Duration = 0.12
													})
												else
													Utilities.Tween(Colorpicker.Colorpicker, {
														Goal = {TextColor3 = Journe.Themes[Journe.SelectedTheme].Group.Items.ImageNText.Normal},
														Duration = 0.12
													})
												end
											end
										end)

										do
											-- Converters
											do
												function HSVToRGB(h, s, v)
													if s == 0 then
														return v, v, v
													end

													h = h / 360
													local i = math.floor(h * 6)
													local f = h * 6 - i
													local p = v * (1 - s)
													local q = v * (1 - f * s)
													local t = v * (1 - (1 - f) * s)

													i = i % 6
													if i == 0 then return v, t, p
													elseif i == 1 then return q, v, p
													elseif i == 2 then return p, v, t
													elseif i == 3 then return p, q, v
													elseif i == 4 then return t, p, v
													elseif i == 5 then return v, p, q
													end
												end

												function RGBToHSV(r, g, b)
													local max = math.max(r, g, b)
													local min = math.min(r, g, b)
													local h, s, v

													v = max
													local delta = max - min

													if max ~= 0 then
														s = delta / max
													else
														s = 0
														h = -1
														return h, s, v
													end

													if r == max then
														h = (g - b) / delta
													elseif g == max then
														h = 2 + (b - r) / delta
													else
														h = 4 + (r - g) / delta
													end

													h = h * 60
													if h < 0 then
														h = h + 360
													end

													return h, s, v
												end

												function RGBToHex(r, g, b)
													return string.format("#%02X%02X%02X", r * 255, g * 255, b * 255)
												end
											end

											function Colorpicker:SetColor(Color, Alpha)
												Colorpicker.Color = Color or Colorpicker.ColorVal
												Colorpicker.Alpha = (100 - Alpha) / 100 or (100 - Colorpicker.AlphaVal) / 100

												local hex = RGBToHex(Colorpicker.Color.R, Colorpicker.Color.G, Colorpicker.Color.B)
												local h, s, v = RGBToHSV(Color.R, Color.G, Color.B)
												local x = s * Colorpicker.Main.AbsoluteSize.X
												local y = (1 - v) * Colorpicker.Main.AbsoluteSize.Y

												Colorpicker.HexCode.Text = string.format([[<font color="#9CA3AF">#</font><font color="#374151">%s</font>]], hex:sub(2))
												Colorpicker.AlphaValue.Text = string.format("%d%%", Alpha)

												Colorpicker.AlphaGradient.Color = ColorSequence.new({
													ColorSequenceKeypoint.new(0, Colorpicker.Color),
													ColorSequenceKeypoint.new(1, Colorpicker.Color)
												})
												Colorpicker.AlphaGradient.Transparency = NumberSequence.new{
													NumberSequenceKeypoint.new(0.000, 1),
													NumberSequenceKeypoint.new(1.000, 0)
												}

												Utilities.Tween(Colorpicker.Colorpicker.Preview, {
													Goal = {BackgroundColor3 = Color},
													Duration = 0.08
												})

												Utilities.Tween(Colorpicker.Cursor, {
													Goal = {Position = UDim2.new(0, x, 0, y)},
													Duration = 0.08
												})

												Utilities.Tween(Colorpicker.Preview, {
													Goal = {BackgroundColor3 = Color},
													Duration = 0.08
												})

												Utilities.Tween(Colorpicker.Cursor, {
													Goal = {ImageColor3 = Color},
													Duration = 0.08
												})

												local RGB = Color3.fromRGB(
													math.floor(Color.R * 255),
													math.floor(Color.G * 255),
													math.floor(Color.B * 255)
												)
												Settings.Callback(RGB, Colorpicker.Alpha)
											end

											function Colorpicker:GetColor()
												return Colorpicker.Color, Colorpicker.Alpha
											end

											Colorpicker.Main.InputBegan:Connect(function(input)
												if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
													Colorpicker.InteractingMain = true
													local function update()
														if not Colorpicker.InteractingMain then return end

														local relative = Vector2.new(
															Mouse.X - Colorpicker.Main.AbsolutePosition.X,
															Mouse.Y - Colorpicker.Main.AbsolutePosition.Y
														)
														local x = math.clamp(relative.X, 0, Colorpicker.Main.AbsoluteSize.X)
														local y = math.clamp(relative.Y, 0, Colorpicker.Main.AbsoluteSize.Y)

														local s = x / Colorpicker.Main.AbsoluteSize.X
														local v = 1 - (y / Colorpicker.Main.AbsoluteSize.Y)
														local h = select(1, RGBToHSV(Colorpicker.Main.BackgroundColor3.R, Colorpicker.Main.BackgroundColor3.G, Colorpicker.Main.BackgroundColor3.B))

														local r, g, b = HSVToRGB(h, s, v)
														Colorpicker:SetColor(Color3.new(r, g, b), Colorpicker.AlphaVal)
													end

													AddConnection(RunService.RenderStepped, update)
													update()
												end
											end)

											Colorpicker.Hue.InputBegan:Connect(function(input)
												if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
													Colorpicker.InteractingHue = true
													local function update()
														if not Colorpicker.InteractingHue then return end
														local MouseLocation = UserInputService:GetMouseLocation()
														local relative = MouseLocation - Colorpicker.Hue.AbsolutePosition
														local h = math.clamp(relative.X / Colorpicker.Hue.AbsoluteSize.X, 0, 1) * 360
														local hr, hg, hb = HSVToRGB(h, 1, 1)
														local cursorPos = Colorpicker.Cursor.Position
														local s = cursorPos.X.Offset / Colorpicker.Main.AbsoluteSize.X
														local v = 1 - (cursorPos.Y.Offset / Colorpicker.Main.AbsoluteSize.Y)
														local r, g, b = HSVToRGB(h, s, v)
														local newColor = Color3.new(r, g, b)

														Utilities.Tween(Colorpicker.Main, {
															Goal = {BackgroundColor3 = Color3.new(hr, hg, hb)},
															Duration = 0.08
														})

														Colorpicker:SetColor(newColor, Colorpicker.AlphaVal)
													end

													AddConnection(RunService.RenderStepped, update)
													update()
												end
											end)

											Colorpicker.AlphaPicker.InputBegan:Connect(function(input)
												if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
													Colorpicker.InteractingAlpha = true
													local function update()
														if not Colorpicker.InteractingAlpha then return end
														local MouseLocation = UserInputService:GetMouseLocation()
														local relative = MouseLocation - Colorpicker.AlphaPicker.AbsolutePosition
														local alpha = math.floor(math.clamp(relative.X / Colorpicker.AlphaPicker.AbsoluteSize.X, 0, 1) * 100)
														Colorpicker.AlphaVal = alpha
														Colorpicker:SetColor(Colorpicker.Color, alpha)
													end

													AddConnection(RunService.RenderStepped, update)
													update()
												end
											end)

											UserInputService.InputEnded:Connect(function(input)
												if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
													Colorpicker.InteractingMain = false
													Colorpicker.InteractingHue = false
													Colorpicker.InteractingAlpha = false
												end
											end)

											Colorpicker:SetColor(Settings.Default.Color, Settings.Default.Alpha)
										end
									end
								end

								Group:UpdateSize()
								Journe.Elements[tostring(#Journe.Elements + 1) .. "Colorpicker"] = {Settings, {Colorpicker.AlphaVal, Colorpicker.ColorVal}}
								return Colorpicker
							end	

							function Group:AddDropdown(Settings)
								Settings = Utilities.Settings({
									Title = "Demo",
									MultipleSelection = false
								}, Settings or {})

								local Dropdown = {
									StoredItems = {},
									Open = false,
									SelectedItems = {},
									CurrentItem = nil,
									MultipleSelection = Settings.MultipleSelection
								}

								do
									Dropdown.Dropdown = Utilities.NewObject("Frame", {
										Parent = Group.Items,
										Name = "Dropdown",
										ZIndex = 2,
										BorderSizePixel = 0,
										BackgroundColor3 = Journe.Themes[Journe.SelectedTheme].Group.Items.Dropdown.DropdownBackground,
										AnchorPoint = Vector2.new(0.5, 0.5),
										Size = UDim2.new(1, -20, 0, 30),
										BorderColor3 = Color3.fromRGB(0, 0, 0)
									})

									Dropdown.Title = Utilities.NewObject("TextLabel", {
										Parent = Dropdown.Dropdown,
										Name = "Title",
										BorderSizePixel = 0,
										ZIndex = 2,
										TextXAlignment = Enum.TextXAlignment.Left,
										BackgroundColor3 = Color3.fromRGB(255, 255, 255),
										TextSize = 12,
										FontFace = Font.new("rbxasset://fonts/families/Roboto.json", Enum.FontWeight.Medium, Enum.FontStyle.Normal),
										TextColor3 = Journe.Themes[Journe.SelectedTheme].Group.Items.ImageNText.Normal,
										BackgroundTransparency = 1,
										Size = UDim2.new(0, 150, 0, 30),
										ClipsDescendants = true,
										BorderColor3 = Color3.fromRGB(0, 0, 0),
										Text = Settings.Title .. " • None"
									})

									Dropdown.Icon = Utilities.NewObject("ImageLabel", {
										Parent = Dropdown.Dropdown,
										Name = "Icon",
										BorderSizePixel = 0,
										ZIndex = 2,
										BackgroundColor3 = Color3.fromRGB(255, 255, 255),
										ImageColor3 = Journe.Themes[Journe.SelectedTheme].Group.Items.ImageNText.Normal,
										AnchorPoint = Vector2.new(1, 0.5),
										Image = "rbxassetid://101920802489602",
										Size = UDim2.new(0, 20, 0, 20),
										BorderColor3 = Color3.fromRGB(0, 0, 0),
										BackgroundTransparency = 1,
										Position = UDim2.new(1, 0, 0.5, 0)
									})

									Dropdown.DropdownCorner = Utilities.NewObject("UICorner", {
										Parent = Dropdown.Dropdown,
										Name = "DropdownCorner",
										CornerRadius = UDim.new(0, 6)
									})

									Dropdown.DropdownStroke = Utilities.NewObject("UIStroke", {
										Parent = Dropdown.Dropdown,
										Name = "DropdownStroke",
										ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
										Color = Journe.Themes[Journe.SelectedTheme].Group.Items.Stroke.Normal
									})

									Dropdown.DropdownPadding = Utilities.NewObject("UIPadding", {
										Parent = Dropdown.Dropdown,
										Name = "DropdownPadding",
										PaddingRight = UDim.new(0, 10),
										PaddingLeft = UDim.new(0, 10)
									})

									Dropdown.Backdrop = Utilities.NewObject("Frame", {
										Parent = Dropdown.Dropdown,
										Name = "Backdrop",
										Visible = false,
										ZIndex = 1,
										BorderSizePixel = 0,
										BackgroundColor3 = Journe.Themes[Journe.SelectedTheme].Group.Items.Dropdown.Backdrop,
										ClipsDescendants = true,
										Size = UDim2.new(1, 20, 0, 0),
										Position = UDim2.new(0, -10, 0, 20),
										BorderColor3 = Color3.fromRGB(0, 0, 0)
									})

									Dropdown.BackdropStroke = Utilities.NewObject("UIStroke", {
										Parent = Dropdown.Backdrop,
										Name = "BackdropStroke",
										ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
										Color = Journe.Themes[Journe.SelectedTheme].Group.Items.Stroke.Normal
									})

									Dropdown.BackdropPadding = Utilities.NewObject("UIPadding", {
										Parent = Dropdown.Backdrop,
										Name = "BackdropPadding",
										PaddingTop = UDim.new(0, 20),
										PaddingRight = UDim.new(0, 10),
										PaddingLeft = UDim.new(0, 10)
									})

									Dropdown.BackdropCorner = Utilities.NewObject("UICorner", {
										Parent = Dropdown.Backdrop,
										Name = "BackdropCorner",
										CornerRadius = UDim.new(0, 6)
									})

									Dropdown.Items = Utilities.NewObject("Frame", {
										Parent = Dropdown.Backdrop,
										Name = "Items",
										BorderSizePixel = 0,
										BackgroundColor3 = Color3.fromRGB(255, 255, 255),
										Size = UDim2.new(1, 0, 1, -10),
										BorderColor3 = Color3.fromRGB(0, 0, 0),
										BackgroundTransparency = 1
									})

									Dropdown.ItemsLayout = Utilities.NewObject("UIListLayout", {
										Parent = Dropdown.Items,
										Name = "ItemsLayout",
										Padding = UDim.new(0, 10),
										SortOrder = Enum.SortOrder.LayoutOrder
									})

									do
										function Dropdown:AddOption(Id, Title, Callback, Selected)
											Callback = Callback or function(ID) end
											local originalId = Id

											while Dropdown.StoredItems[Id] do
												if tonumber(Id) then
													Id = tostring(tonumber(Id) + 1)
												else
													Id = Id .. "1"
												end
											end

											Dropdown.StoredItems[Id] = {
												Selected = Selected or false
											}

											if Selected then
												table.insert(Dropdown.SelectedItems, {Id = Id, Title = Title})
											end

											do
												Dropdown.StoredItems[Id].Item = Utilities.NewObject("Frame", {
													Parent = Dropdown.Items,
													Name = "Option",
													BorderSizePixel = 0,
													BackgroundColor3 = Color3.fromRGB(255, 255, 255),
													Size = UDim2.new(1, 0, 0, 20),
													BorderColor3 = Color3.fromRGB(0, 0, 0),
													BackgroundTransparency = 1,
													ZIndex = 5
												})

												Dropdown.StoredItems[Id].Title = Utilities.NewObject("TextLabel", {
													Parent = Dropdown.StoredItems[Id].Item,
													Name = "Title",
													BorderSizePixel = 0,
													TextXAlignment = Enum.TextXAlignment.Left,
													BackgroundColor3 = Color3.fromRGB(255, 255, 255),
													TextSize = 12,
													FontFace = Font.new("rbxasset://fonts/families/Roboto.json", Enum.FontWeight.Medium, Enum.FontStyle.Normal),
													TextColor3 = Color3.fromRGB(127, 127, 127),
													BackgroundTransparency = 1,
													Size = UDim2.new(0, 150, 0, 20),
													ClipsDescendants = true,
													BorderColor3 = Color3.fromRGB(0, 0, 0),
													Text = Title or "Option",
													ZIndex = 5
												})

												Dropdown.StoredItems[Id].OptionPadding = Utilities.NewObject("UIPadding", {
													Parent = Dropdown.StoredItems[Id].Item,
													Name = "OptionPadding",
													PaddingRight = UDim.new(0, 10),
													PaddingLeft = UDim.new(0, 5)
												})

												do
													Dropdown.StoredItems[Id].Item.MouseEnter:Connect(function()
														if not Dropdown.StoredItems[Id].Selected then
															Utilities.Tween(Dropdown.StoredItems[Id].Title, {
																Goal = {TextColor3 = Journe.Themes[Journe.SelectedTheme].Group.Items.ImageNText.Hover},
																Duration = 0.12
															})
														end
													end)

													Dropdown.StoredItems[Id].Item.MouseLeave:Connect(function()
														if not Dropdown.StoredItems[Id].Selected then
															Utilities.Tween(Dropdown.StoredItems[Id].Title, {
																Goal = {TextColor3 = Journe.Themes[Journe.SelectedTheme].Group.Items.ImageNText.Normal},
																Duration = 0.12
															})
														end
													end)

													Dropdown.StoredItems[Id].Item.InputBegan:Connect(function(input)
														if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
															if Dropdown.MultipleSelection then

																Dropdown.StoredItems[Id].Selected = not Dropdown.StoredItems[Id].Selected

																if Dropdown.StoredItems[Id].Selected then
																	Utilities.Tween(Dropdown.StoredItems[Id].Title, {
																		Goal = {TextColor3 = Color3.fromRGB(226, 226, 226)},
																		Duration = 0.12
																	})
																	table.insert(Dropdown.SelectedItems, {Id = Id, Title = Title})
																else
																	Utilities.Tween(Dropdown.StoredItems[Id].Title, {
																		Goal = {TextColor3 = Color3.fromRGB(126, 126, 126)},
																		Duration = 0.12
																	})
																	for i, item in ipairs(Dropdown.SelectedItems) do
																		if item.Id == Id then
																			table.remove(Dropdown.SelectedItems, i)
																			break
																		end
																	end
																end

																if #Dropdown.SelectedItems == 0 then
																	Dropdown.Title.Text = Settings.Title .. " • None"
																else
																	Dropdown.Title.Text = Settings.Title .. " • " .. #Dropdown.SelectedItems .. " Selected"
																end
															else

																if Dropdown.CurrentItem then
																	Utilities.Tween(Dropdown.CurrentItem.Title, {
																		Goal = {TextColor3 = Color3.fromRGB(126, 126, 126)},
																		Duration = 0.12
																	})
																	Dropdown.CurrentItem.Selected = false
																end

																Utilities.Tween(Dropdown.StoredItems[Id].Title, {
																	Goal = {TextColor3 = Color3.fromRGB(226, 226, 226)},
																	Duration = 0.12
																})

																Dropdown.StoredItems[Id].Selected = true
																Dropdown.CurrentItem = Dropdown.StoredItems[Id]
																Dropdown.Title.Text = Settings.Title .. " • " .. Title
															end

															Callback(Id, Title)
														end
													end)

													if not Dropdown.MultipleSelection and Dropdown.CurrentItem == nil then
														Utilities.Tween(Dropdown.StoredItems[Id].Title, {
															Goal = {TextColor3 = Color3.fromRGB(226, 226, 226)},
															Duration = 0.12
														})

														Dropdown.StoredItems[Id].Selected = true
														Dropdown.CurrentItem = Dropdown.StoredItems[Id]
														Dropdown.Title.Text = Settings.Title .. " • " .. Title
													end
												end
											end

											Dropdown.StoredItems[Id].Callback = Callback
										end

										function Dropdown:Remove(Id)
											if Dropdown.StoredItems[Id] then

												if Dropdown.CurrentItem == Dropdown.StoredItems[Id] then
													Dropdown.CurrentItem = nil
													Dropdown.Title.Text = Settings.Title .. " • None"
												end

												if Dropdown.MultipleSelection then
													for i, item in ipairs(Dropdown.SelectedItems) do
														if item.Id == Id then
															table.remove(Dropdown.SelectedItems, i)
															break
														end
													end

													if #Dropdown.SelectedItems == 0 then
														Dropdown.Title.Text = Settings.Title .. " • None"
													else
														Dropdown.Title.Text = Settings.Title .. " • " .. #Dropdown.SelectedItems .. " Selected"
													end
												end

												Dropdown.StoredItems[Id].Item:Destroy()
												Dropdown.StoredItems[Id] = nil
											end
										end

										function Dropdown:GetSelected()
											if Dropdown.MultipleSelection then

												return Dropdown.SelectedItems
											else

												if Dropdown.CurrentItem then
													for id, item in pairs(Dropdown.StoredItems) do
														if item == Dropdown.CurrentItem then
															return {
																Id = id,
																Title = item.Title.Text
															}
														end
													end
												end
											end
											return {}
										end

										function Dropdown:Clear()

											if Dropdown.MultipleSelection then
												for _, item in pairs(Dropdown.StoredItems) do
													Utilities.Tween(item.Title, {
														Goal = {TextColor3 = Color3.fromRGB(126, 126, 126)},
														Duration = 0.12
													})
													item.Selected = false
												end
												Dropdown.SelectedItems = {}
											else
												if Dropdown.CurrentItem then
													Utilities.Tween(Dropdown.CurrentItem.Title, {
														Goal = {TextColor3 = Color3.fromRGB(126, 126, 126)},
														Duration = 0.12
													})
													Dropdown.CurrentItem.Selected = false
													Dropdown.CurrentItem = nil
												end
											end

											Dropdown.Title.Text = Settings.Title .. " • None"

											if Dropdown.Open then
												Dropdown.Open = false
												Dropdown.Backdrop.Visible = true
												Utilities.Tween(Dropdown.Backdrop, {
													Goal = {Size = UDim2.new(1, 20, 0, 0)},
													Duration = 0.12,
													Callback = coroutine.wrap(function()
														task.wait(0.16)
														Dropdown.Backdrop.Visible = false
													end)()
												})
											end
										end

										function Dropdown:Refresh(NewOptions)

											for id in pairs(Dropdown.StoredItems) do
												Dropdown.StoredItems[id].Item:Destroy()
												Dropdown.StoredItems[id] = nil
											end

											Dropdown.SelectedItems = {}
											Dropdown.CurrentItem = nil
											Dropdown.Title.Text = Settings.Title .. " • None"

											if Dropdown.Open then
												Dropdown.Open = false
												Dropdown.Backdrop.Visible = true
												Utilities.Tween(Dropdown.Backdrop, {
													Goal = {Size = UDim2.new(1, 20, 0, 0)},
													Duration = 0.12,
													Callback = coroutine.wrap(function()
														task.wait(0.16)
														Dropdown.Backdrop.Visible = false
													end)()
												})
											end

											if type(NewOptions) == "table" then
												for _, option in ipairs(NewOptions) do
													if type(option) == "table" then
														Dropdown:AddOption(
															option.Id or option.id or option.Title or option.title,
															option.Title or option.title,
															option.Callback or option.callback,
															option.Selected or option.selected
														)
													end
												end
											end
										end

										Dropdown.Dropdown.MouseEnter:Connect(function()
											Utilities.Tween(Dropdown.Title, {
												Goal = {TextColor3 = Journe.Themes[Journe.SelectedTheme].Group.Items.ImageNText.Hover},
												Duration = 0.12
											})
											Utilities.Tween(Dropdown.Icon, {
												Goal = {ImageColor3 = Journe.Themes[Journe.SelectedTheme].Group.Items.ImageNText.Hover},
												Duration = 0.12
											})
										end)

										Dropdown.Dropdown.MouseLeave:Connect(function()
											Utilities.Tween(Dropdown.Title, {
												Goal = {TextColor3 = Journe.Themes[Journe.SelectedTheme].Group.Items.ImageNText.Normal},
												Duration = 0.12
											})
											Utilities.Tween(Dropdown.Icon, {
												Goal = {ImageColor3 = Journe.Themes[Journe.SelectedTheme].Group.Items.ImageNText.Normal},
												Duration = 0.12
											})
										end)

										Dropdown.Dropdown.InputBegan:Connect(function(input)
											if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
												Dropdown.Open = not Dropdown.Open
												if not Dropdown.Open then
													Dropdown.Backdrop.Visible = true
													Dropdown.Dropdown.ZIndex = 2
													Dropdown.Title.ZIndex = 2
													Dropdown.Icon.ZIndex = 2
													Dropdown.Backdrop.ZIndex = 1
													Utilities.Tween(Dropdown.Backdrop, {
														Goal = {Size = UDim2.new(1, 20, 0, 0)},
														Duration = 0.12,
														Callback = coroutine.wrap(function()
															task.wait(0.16)
															Dropdown.Backdrop.Visible = false
														end)()
													})
												else
													local count = 0
													for _ in pairs(Dropdown.StoredItems) do
														count += 1
													end

													Dropdown.Dropdown.ZIndex = 6
													Dropdown.Title.ZIndex = 6
													Dropdown.Icon.ZIndex = 6
													Dropdown.Backdrop.ZIndex = 5
													Dropdown.Backdrop.Visible = true
													Utilities.Tween(Dropdown.Backdrop, {
														Goal = {Size = UDim2.new(1, 20, 0, 30 + (count * 30) - 10)},
														Duration = 0.12
													})

													Dropdown.Dropdown.InputBegan:Connect(function(input)
														if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
															local absolutePosition = Dropdown.Dropdown.AbsolutePosition
															local absoluteSize = Dropdown.Dropdown.AbsoluteSize
															local mousePosition = Vector2.new(input.Position.X, input.Position.Y)

															local isInDropdownBounds = mousePosition.X >= absolutePosition.X - 10 and
																mousePosition.X <= absolutePosition.X + absoluteSize.X + 10 and
																mousePosition.Y >= absolutePosition.Y and
																mousePosition.Y <= absolutePosition.Y + absoluteSize.Y + Dropdown.Backdrop.AbsoluteSize.Y

															if not isInDropdownBounds then
																Dropdown.Open = false
																Dropdown.Backdrop.Visible = true
																Dropdown.Dropdown.ZIndex = 2
																Dropdown.Title.ZIndex = 2
																Dropdown.Icon.ZIndex = 2
																Dropdown.Backdrop.ZIndex = 1
																Utilities.Tween(Dropdown.Backdrop, {
																	Goal = {Size = UDim2.new(1, 20, 0, 0)},
																	Duration = 0.12,
																	Callback = coroutine.wrap(function()
																		task.wait(0.16)
																		Dropdown.Backdrop.Visible = false
																	end)()
																})
															end
														end
													end)
												end
											end
										end)
									end
								end

								Group:UpdateSize()
								return Dropdown
							end
						end
					end

					Journe.Elements[tostring(#Journe.Elements + 1) .. "Group"] = {Settings}
					return Group
				end
			end

			Journe.Elements[tostring(#Journe.Elements + 1) .. "Tab"] = {Settings}
			return Tab
		end
	end

	-- Retared peice of shit
	--local function Reload(data)
	--	Interface.Core:Destroy()
	--	Interface.Actions:Destroy()

	--	local Reloaded = Journe:CreateWindow()
	--end

	function Interface:SetTheme(Theme)
		if (Theme == "Dark" or Theme == "Light") and Journe.SelectedTheme ~= Theme then
			Journe.SelectedTheme = Theme
			Journe:Notify({
				Title = "Themes!",
				Type = "Warning",
				Duration = 10,
				Description = "Please restart for themes to\ntake effect"
			})
		elseif Journe.SelectedTheme ~= Theme then
			Journe.SelectedTheme = "Light"
			Journe:Notify({
				Title = "Themes!",
				Type = "Warning",
				Duration = 10,
				Description = "Please restart for themes to\ntake effect"
			})
		end
	end

	return Interface
end

return Journe
