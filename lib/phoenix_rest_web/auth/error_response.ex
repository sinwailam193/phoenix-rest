defmodule PhoenixRestWeb.Auth.ErrorResponse.Unauthorized do
    defexception [message:  "Unauthorized", plug_status: 401]
end

defmodule PhoenixRestWeb.Auth.ErrorResponse.Forbidden do
    defexception [message:  "You do not have access to this resource.", plug_status: 403]
end

defmodule PhoenixRestWeb.Auth.ErrorResponse.NotFound do
    defexception [message:  "Not found.", plug_status: 404]
end

defmodule PhoenixRestWeb.Auth.ErrorResponse.InternalServerError do
    defexception [message:  "Internal server error.", plug_status: 500]
end
