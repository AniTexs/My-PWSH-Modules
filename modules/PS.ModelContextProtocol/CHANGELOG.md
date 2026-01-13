# Changelog

All notable changes to the PS.ModelContextProtocol module will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [0.1.0] - 2026-01-13

### Added

#### Core MCP Server Functionality
- **Initialize-MCPServer**: Initializes the MCP server and auto-discovers PS.ModelContextProtocol.* submodules
  - Automatic submodule discovery in configured module paths
  - Tool registration from submodules
  - Force reinitialization with -Force parameter
  - Verbose logging for troubleshooting

- **Get-MCPTools**: Retrieves registered tools with optional filtering
  - Filter by tool name pattern
  - Filter by submodule origin
  - Returns complete tool definitions

- **Invoke-MCPTool**: Executes registered tools with argument validation
  - Named tool invocation
  - Argument splatting support
  - Error handling and reporting
  - ShouldProcess support for auditing

- **Register-MCPSubmodule**: Manually registers submodules
  - Explicit module registration
  - Support for non-standard module paths
  - Tool registration from manually loaded modules

- **Get-MCPServerStatus**: Provides MCP server status and statistics
  - Server initialization status
  - Total tool count
  - Loaded submodule list
  - Detailed submodule information

- **New-MCPToolDefinition**: Factory function for creating tool definitions
  - Standardized tool definition format
  - Input schema validation
  - Consistent tool metadata

#### Internal Functions
- **Test-MCPToolDefinition**: Validates tool definitions for completeness
  - Property existence checking
  - Name format validation
  - Handler type validation
  - Schema validation

#### Documentation
- **README.md**: Comprehensive module documentation
  - Architecture overview
  - Quick start guide
  - Detailed API documentation
  - Best practices for submodule authors
  - Troubleshooting guide
  - Integration patterns for AI agents

- **SUBMODULE_TEMPLATE.md**: Complete submodule creation guide
  - Template structure and naming conventions
  - Example Active Directory integration
  - Tool implementation patterns
  - Error handling best practices
  - Testing instructions

### Features
- Automatic submodule discovery using PS.ModelContextProtocol.* naming convention
- Tool registration and management system
- Global MCP context for server state management
- Support for scriptblock and function name handlers
- Flexible input schema definition
- Standardized tool definition format
- Error handling and logging infrastructure

### Module Metadata
- GUID: 1c71e007-83d3-432b-b83e-ab1ce192b655
- Author: Nicolai Estrup Jacobsen
- Tags: MCP, AI, Agent, Automation, JSON-RPC, Protocol
- PowerShell Version: 7.0+

---

## Future Roadmap

### Planned for 0.2.0
- JSON-RPC 2.0 protocol adapter
- HTTP/WebSocket server implementation
- Tool result serialization improvements
- Performance metrics collection
- Audit logging enhancements

### Planned for 0.3.0
- Tool dependency management
- Conditional tool availability (role-based, context-based)
- Tool versioning support
- Schema validation against OpenAPI/JSON Schema
- Caching layer for frequently accessed tools

### Planned for 1.0.0
- Full MCP specification compliance
- Production-ready server implementation
- Comprehensive security model
- Advanced authentication/authorization
- Rate limiting and throttling
