local M = {}

local function normalize_commands(spec)
  if type(spec) ~= "table" then return {} end

  local commands = {}

  for _, value in ipairs(spec) do
    commands[#commands + 1] = value
  end

  return commands
end

local function evaluate_list(commands, spec_type)
  local executables = normalize_commands(commands)
  local result = {
    available = false,
    executable = nil,
    executables = executables,
    reason = "missing_executable",
  }

  if #executables == 0 then
    result.reason = "missing_mapping"
    return result
  end

  if spec_type == "all" then
    for _, command in ipairs(executables) do
      if vim.fn.executable(command) ~= 1 then
        result.reason = "missing_executable"
        result.available = false
        return result
      end
    end

    result.available = true
    result.executable = executables[1]
    result.reason = "available"

    return result
  end

  for _, command in ipairs(executables) do
    if vim.fn.executable(command) == 1 then
      result.available = true
      result.executable = command
      result.reason = "available"

      return result
    end
  end

  return result
end

function M.evaluate(spec)
  if spec == nil then
    return {
      available = false,
      executable = nil,
      executables = {},
      reason = "missing_mapping",
    }
  end

  if spec == true then
    return {
      available = true,
      executable = nil,
      executables = {},
      reason = "forced_available",
    }
  end

  if spec == false then
    return {
      available = false,
      executable = nil,
      executables = {},
      reason = "disabled",
    }
  end

  if type(spec) == "string" then
    local is_available = vim.fn.executable(spec) == 1

    return {
      available = is_available,
      executable = is_available and spec or nil,
      executables = { spec },
      reason = is_available and "available" or "missing_executable",
    }
  end

  if type(spec) ~= "table" then
    return {
      available = false,
      executable = nil,
      executables = {},
      reason = "missing_mapping",
    }
  end

  if spec.all ~= nil then return evaluate_list(spec.all, "all") end

  if spec.any ~= nil then return evaluate_list(spec.any, "any") end

  return evaluate_list(spec, "any")
end

function M.first_available(spec) return M.evaluate(spec).executable end

return M
