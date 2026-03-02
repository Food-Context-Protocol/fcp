# Food Context Protocol (FCP) Specification

**Version**: 2026-02-04
**Status**: Draft
**Authors**: Food Context Protocol Contributors

---

## Table of Contents

1. [Overview](#1-overview)
2. [Architecture](#2-architecture)
3. [Transport Layer](#3-transport-layer)
4. [Core Capabilities](#4-core-capabilities)
5. [Tool Definitions](#5-tool-definitions)
6. [Agents](#6-agents)
7. [Data Types](#7-data-types)
8. [Versioning](#8-versioning)
9. [Security](#9-security)
10. [Error Handling](#10-error-handling)

---

## 1. Overview

### 1.1 What is FCP?

The **Food Context Protocol (FCP)** is an open protocol specification for AI-powered food intelligence. It defines a standard interface for tools and agents that analyze, discover, manage, and generate content about food.

FCP is designed to work with large language models (LLMs) like Google Gemini, enabling rich food-related interactions through:

- **Multimodal analysis** - Understanding food from images
- **Structured extraction** - Converting unstructured food data into typed schemas
- **Real-time grounding** - Accessing current information about recalls, restaurants, and recipes
- **Content generation** - Creating shareable food content

### 1.2 Design Principles

1. **Gemini-Native**: Optimized for Gemini 3's capabilities (function calling, grounding, thinking, vision)
2. **Type-Safe**: All inputs and outputs are defined with JSON Schema
3. **Composable**: Tools can be chained into complex workflows
4. **MCP-Compatible**: Transport layer is compatible with the Model Context Protocol

### 1.3 Relationship to MCP

FCP uses the [Model Context Protocol (MCP)](https://modelcontextprotocol.io) as its primary transport layer for AI assistant integration. FCP tools are exposed as MCP tools, allowing seamless integration with:

- Claude Desktop
- Gemini CLI
- Any MCP-compatible client

### 1.4 Target Audience

- **AI Assistant Developers**: Building food-aware assistants
- **Food App Developers**: Adding AI capabilities to food apps
- **Health Platforms**: Integrating nutrition tracking and analysis
- **Content Creators**: Automating food content generation

---

## 2. Architecture

### 2.1 System Overview

```text
┌─────────────────────────────────────────────────────────────┐
│                       FCP Clients                            │
│  ┌─────────────┐  ┌─────────────┐  ┌─────────────────────┐  │
│  │   Claude    │  │   Gemini    │  │    Mobile/Web App   │  │
│  │   Desktop   │  │    CLI      │  │    (REST Client)    │  │
│  └──────┬──────┘  └──────┬──────┘  └──────────┬──────────┘  │
└─────────┼────────────────┼─────────────────────┼────────────┘
          │                │                     │
          │ MCP (stdio)    │ MCP (stdio)         │ REST/HTTP
          │                │                     │
┌─────────▼────────────────▼─────────────────────▼────────────┐
│                       FCP Server                             │
│  ┌───────────────────────────────────────────────────────┐  │
│  │                    Tool Router                         │  │
│  │  Validates requests, routes to appropriate handler     │  │
│  └───────────────────────────────────────────────────────┘  │
│                              │                               │
│         ┌────────────────────┼────────────────────┐         │
│         ▼                    ▼                    ▼         │
│  ┌─────────────┐      ┌─────────────┐      ┌───────────┐   │
│  │   Agents    │      │    Tools    │      │ Resources │   │
│  │             │      │             │      │           │   │
│  │ - Media     │      │ - Analysis  │      │ - Meals   │   │
│  │ - Discovery │      │ - Discovery │      │ - Recipes │   │
│  │ - Freshness │      │ - Safety    │      │ - Pantry  │   │
│  │ - Content   │      │ - Content   │      │ - Profile │   │
│  └──────┬──────┘      └──────┬──────┘      └─────┬─────┘   │
│         │                    │                   │          │
│         └────────────────────┼───────────────────┘          │
│                              ▼                               │
│  ┌───────────────────────────────────────────────────────┐  │
│  │                   Service Layer                        │  │
│  │  ┌─────────┐  ┌─────────┐  ┌─────────┐  ┌─────────┐  │  │
│  │  │ Gemini  │  │  Maps   │  │Firebase │  │  USDA   │  │  │
│  │  │   API   │  │   API   │  │Firestore│  │   API   │  │  │
│  │  └─────────┘  └─────────┘  └─────────┘  └─────────┘  │  │
│  └───────────────────────────────────────────────────────┘  │
└─────────────────────────────────────────────────────────────┘
                              │
                              ▼
┌─────────────────────────────────────────────────────────────┐
│                    Gemini 3 Flash Preview                    │
│  ┌─────────────┐ ┌─────────────┐ ┌─────────────┐           │
│  │  Function   │ │   Google    │ │  Extended   │           │
│  │  Calling    │ │  Grounding  │ │  Thinking   │           │
│  └─────────────┘ └─────────────┘ └─────────────┘           │
│  ┌─────────────┐ ┌─────────────┐ ┌─────────────┐           │
│  │ Multimodal  │ │    Code     │ │   Live API  │           │
│  │   Vision    │ │  Execution  │ │   (Voice)   │           │
│  └─────────────┘ └─────────────┘ └─────────────┘           │
└─────────────────────────────────────────────────────────────┘
```

### 2.2 Core Components

#### Agents

Autonomous workflows that orchestrate multiple tools to accomplish complex tasks. Each agent is implemented using Pydantic AI for type safety.

#### Tools

Individual operations that perform specific food-related tasks. Tools are the building blocks that agents compose.

#### Resources

Data stores that tools read from and write to. The primary resource is a Firebase Firestore database.

#### Services

External API integrations that provide capabilities to tools:

- **Gemini API**: LLM for analysis, generation, and reasoning
- **Maps API**: Location-based restaurant discovery
- **USDA API**: Nutrition database lookups
- **Firebase**: Data persistence and authentication

---

## 3. Transport Layer

### 3.1 MCP Transport (Primary)

FCP uses JSON-RPC 2.0 over stdio for MCP compatibility.

#### Request Format

```json
{
  "jsonrpc": "2.0",
  "id": "req-123",
  "method": "tools/call",
  "params": {
    "name": "analyze_meal",
    "arguments": {
      "image_url": "https://example.com/food.jpg"
    }
  }
}
```

#### Response Format

```json
{
  "jsonrpc": "2.0",
  "id": "req-123",
  "result": {
    "content": [
      {
        "type": "text",
        "text": "{\"dish_name\": \"Spaghetti Carbonara\", ...}"
      }
    ]
  }
}
```

### 3.2 REST Transport (Secondary)

For mobile/web apps, FCP provides a REST API.

#### Base URL

```text
https://api.fcp.dev/v1
```

#### Authentication

Firebase ID tokens in the Authorization header:

```text
Authorization: Bearer <firebase-id-token>
```

#### Endpoint Pattern

```text
POST /tools/{tool_name}
Content-Type: application/json

{
  "image_url": "https://example.com/food.jpg"
}
```

### 3.3 Message Types

| Type | Description | Response Expected |
|------|-------------|-------------------|
| Request | Tool invocation | Yes |
| Response | Tool result | No |
| Notification | Server event | No |
| Error | Failure information | No |

---

## 4. Core Capabilities

FCP capabilities are organized into domains. Each capability maps to one or more Gemini features.

### 4.1 Food Analysis

Transform food images and text into structured data.

| Capability | Description | Gemini Feature |
|------------|-------------|----------------|
| `analyze_meal` | Image → structured food data | Multimodal + JSON Mode |
| `analyze_meal_v2` | Advanced with function calling | Function Calling |
| `analyze_with_thinking` | Complex dish reasoning | Extended Thinking |
| `analyze_agentic_vision` | Multi-step visual analysis | Agentic Vision |

**Example Flow**:

```text
Image → Gemini Vision → Structured JSON
                     ↓
{
  "dish_name": "Pad Thai",
  "cuisine": "Thai",
  "ingredients": [...],
  "nutrition": {...}
}
```

### 4.2 Food Discovery

Find restaurants, recipes, and ingredients based on preferences.

| Capability | Description | Gemini Feature |
|------------|-------------|----------------|
| `find_nearby_food` | Location-based venues | Maps API |
| `discover_restaurants` | Taste-matched recommendations | Google Search Grounding |
| `discover_recipes` | Ingredient-based recipes | Grounding |
| `discover_seasonal` | Seasonal ingredients | Grounding |

**Example Flow**:

```text
User Taste Profile + Location
         ↓
    Gemini Grounding (Google Search)
         ↓
[
  {"name": "Sushi Nakazawa", "match_score": 0.95, ...},
  {"name": "Masa", "match_score": 0.91, ...}
]
```

### 4.3 Content Generation

Create shareable food content from meal data.

| Capability | Description | Gemini Feature |
|------------|-------------|----------------|
| `generate_social_post` | Platform-optimized captions | Large Context |
| `generate_blog_post` | SEO-optimized articles | Extended Thinking |
| `generate_food_story` | Narrative food stories | Thinking |
| `generate_recipe_video` | Cooking video generation | Veo 3.1 |

### 4.4 Safety & Health

Ensure food safety and dietary compliance.

| Capability | Description | Gemini Feature |
|------------|-------------|----------------|
| `check_food_recalls` | Real-time recall checking | Google Search Grounding |
| `check_allergen_interactions` | Drug-food interactions | Grounding |
| `check_dietary_compatibility` | Diet compliance | JSON Mode |

### 4.5 Voice Interface

Voice-based food logging and queries.

| Capability | Description | Gemini Feature |
|------------|-------------|----------------|
| `process_voice_meal_log` | Voice → meal entry | Live API |
| `voice_food_query` | Voice Q&A about food | Live API |

### 4.6 Knowledge & Enrichment

Enhance food data with external knowledge.

| Capability | Description | Data Source |
|------------|-------------|-------------|
| `lookup_product` | Barcode → product info | Open Food Facts |
| `enrich_nutrition` | Add detailed nutrition | USDA FoodData Central |
| `search_knowledge` | Food database search | USDA + OFF |

### 4.7 Gemini 3 Features (Complete List)

FCP leverages **15 Gemini 3 features** for comprehensive food intelligence:

| # | Feature | FCP Method | Use Case |
|---|---------|------------|----------|
| 1 | **Multimodal (image + text)** | `analyze_image()` | Meal photo analysis |
| 2 | **JSON Mode** | All `generate_*` methods | Structured nutrition data |
| 3 | **Google Search Grounding** | `generate_with_grounding()` | Food safety, recalls |
| 4 | **Thinking/Reasoning** | `generate_with_thinking()` | Complex taste analysis |
| 5 | **Code Execution** | `generate_with_code_execution()` | Portion calculations |
| 6 | **1M Context Window** | `generate_with_large_context()` | Lifetime food history |
| 7 | **Streaming** | `generate_content_stream()` | Real-time UI feedback |
| 8 | **Function Calling** | `generate_with_tools()` | Agentic workflows |
| 9 | **Context Caching** | `create_context_cache()` | Efficient history queries |
| 10 | **Media Resolution** | `analyze_image_with_resolution()` | Cost-optimized images |
| 11 | **URL Context** | `generate_json_with_url_context()` | Recipe import from URLs |
| 12 | **Imagen 3** | `generate_image()` | Meal visualizations |
| 13 | **Veo 3.1** | `generate_video()` | Cooking tutorials |
| 14 | **Live API** | `create_live_session()` | Voice meal logging |
| 15 | **Deep Research** | `generate_deep_research()` | Food trend analysis |

#### Cost Optimization with Media Resolution

FCP uses media_resolution to control token usage for image analysis:

| Resolution | Tokens | Use Case | Cost Savings |
|------------|--------|----------|--------------|
| `low` | ~70 | Quick food detection | ~93% |
| `medium` | ~560 | General meal logging | ~50% |
| `high` | ~1120 | Detailed nutrition extraction | Baseline |

#### Multi-Tool Combination

The `generate_with_all_tools()` method enables combining multiple Gemini features in a single request:

```python
result = await gemini.generate_with_all_tools(
    prompt="Analyze this meal and find similar restaurants nearby",
    enable_grounding=True,        # Google Search
    enable_code_execution=True,   # Calculations
    image_url="https://..."       # Multimodal
)
```

---

## 5. Tool Definitions

Tools are organized by domain. Each tool has a unique name, description, input schema, and output schema.

### 5.1 Meal Management (CRUD)

#### `add_meal`

Create a new food log entry.

**Input Schema**:

```json
{
  "type": "object",
  "properties": {
    "user_id": {"type": "string", "description": "User identifier"},
    "dish_name": {"type": "string", "description": "Name of the dish"},
    "venue": {"type": "string", "description": "Restaurant or location"},
    "notes": {"type": "string", "description": "User notes"},
    "image_url": {"type": "string", "format": "uri", "description": "Food image URL"},
    "created_at": {"type": "string", "format": "date-time"}
  },
  "required": ["user_id", "dish_name"]
}
```

**Output Schema**:

```json
{
  "type": "object",
  "properties": {
    "id": {"type": "string"},
    "dish_name": {"type": "string"},
    "venue": {"type": "string"},
    "notes": {"type": "string"},
    "image_url": {"type": "string"},
    "created_at": {"type": "string", "format": "date-time"},
    "nutrition": {"$ref": "#/definitions/Nutrition"},
    "cuisine": {"type": "string"},
    "ingredients": {"type": "array", "items": {"$ref": "#/definitions/Ingredient"}}
  }
}
```

#### `get_meal`

Retrieve a single meal by ID.

#### `get_meals`

List meals with pagination and filtering.

#### `update_meal`

Update meal fields.

#### `delete_meal`

Delete a meal entry.

#### `donate_meal`

Mark a meal as donated (for food sharing).

### 5.2 Food Analysis

#### `analyze_meal`

Analyze a food image using Gemini multimodal.

**Input Schema**:

```json
{
  "type": "object",
  "properties": {
    "image_url": {"type": "string", "format": "uri"}
  },
  "required": ["image_url"]
}
```

**Output Schema**:

```json
{
  "type": "object",
  "properties": {
    "dish_name": {"type": "string"},
    "cuisine": {"type": "string"},
    "cooking_method": {"type": "string"},
    "ingredients": {
      "type": "array",
      "items": {
        "type": "object",
        "properties": {
          "name": {"type": "string"},
          "amount": {"type": "string"},
          "is_visible": {"type": "boolean"}
        }
      }
    },
    "nutrition": {"$ref": "#/definitions/Nutrition"},
    "allergens": {"type": "array", "items": {"type": "string"}},
    "dietary_tags": {"type": "array", "items": {"type": "string"}},
    "spice_level": {"type": "integer", "minimum": 0, "maximum": 5},
    "confidence": {"type": "number", "minimum": 0, "maximum": 1}
  }
}
```

#### `analyze_meal_v2`

Advanced analysis using Gemini function calling for structured extraction.

#### `analyze_with_thinking`

Analysis with extended thinking for complex dishes.

### 5.3 Discovery

#### `find_nearby_food`

Find restaurants near a location using Google Maps.

**Input Schema**:

```json
{
  "type": "object",
  "properties": {
    "latitude": {"type": "number"},
    "longitude": {"type": "number"},
    "radius_meters": {"type": "integer", "default": 1000},
    "food_type": {"type": "string"}
  },
  "required": ["latitude", "longitude"]
}
```

#### `discover_restaurants`

Get taste-matched restaurant recommendations using Gemini grounding.

#### `discover_recipes`

Find recipes based on available ingredients.

#### `discover_seasonal`

Discover seasonal ingredients for a location.

### 5.4 Recipe Management

#### `save_recipe`

Save a recipe to the user's library.

#### `extract_recipe_from_media`

Extract recipe from an image or text using Gemini vision.

#### `scale_recipe`

Adjust recipe quantities for different serving sizes (uses Gemini code execution).

#### `standardize_recipe`

Normalize recipe format to schema.org Recipe schema.

### 5.5 Inventory Management

#### `add_to_pantry`

Add ingredient to user's pantry.

#### `check_pantry_expiry`

Check for expiring ingredients.

#### `suggest_recipe_from_pantry`

Suggest recipes based on pantry contents.

### 5.6 Safety

#### `check_food_recalls`

Check for active food recalls using Gemini grounding.

**Input Schema**:

```json
{
  "type": "object",
  "properties": {
    "food_name": {"type": "string"},
    "brand": {"type": "string"}
  },
  "required": ["food_name"]
}
```

**Output Schema**:

```json
{
  "type": "object",
  "properties": {
    "has_recall": {"type": "boolean"},
    "recalls": {
      "type": "array",
      "items": {
        "type": "object",
        "properties": {
          "title": {"type": "string"},
          "reason": {"type": "string"},
          "severity": {"enum": ["low", "medium", "high", "critical"]},
          "date": {"type": "string", "format": "date"},
          "source_url": {"type": "string", "format": "uri"}
        }
      }
    }
  }
}
```

#### `check_allergen_interactions`

Check for drug-food interactions.

#### `check_dietary_compatibility`

Verify dish compatibility with dietary restrictions.

### 5.7 Content Generation

#### `generate_social_post`

Generate platform-optimized social media post.

**Input Schema**:

```json
{
  "type": "object",
  "properties": {
    "meal": {"$ref": "#/definitions/Meal"},
    "platform": {"enum": ["instagram", "twitter", "facebook", "tiktok"]},
    "style": {"enum": ["casual", "professional", "humorous", "informative"]}
  },
  "required": ["meal"]
}
```

#### `generate_blog_post`

Generate SEO-optimized blog content.

#### `generate_food_story`

Generate narrative food stories.

### 5.8 Voice

#### `process_voice_meal_log`

Convert voice input to meal log entry using Gemini Live API.

#### `voice_food_query`

Answer food-related questions via voice.

### 5.9 Analytics

#### `get_nutrition_stats`

Calculate nutrition statistics over a time period.

#### `analyze_eating_patterns`

Identify eating patterns and habits.

#### `generate_research_report`

Generate comprehensive food research report.

### 5.10 External Integrations

#### `lookup_product`

Look up product by barcode using Open Food Facts.

#### `enrich_nutrition`

Enrich meal with USDA nutrition data.

---

## 6. Agents

Agents are autonomous workflows that orchestrate multiple tools. Each agent is implemented using Pydantic AI for type safety.

### 6.1 MediaProcessingAgent

**Purpose**: Process food photos from camera roll or batch uploads.

**Workflow**:

1. Filter images to identify food photos
2. Analyze each food image
3. Extract nutrition and ingredients
4. Optionally create food log entries

**Tools Used**:

- `detect_food_in_image`
- `analyze_meal`
- `identify_ingredients`
- `extract_nutrition`
- `add_meal`

**Input Model**:

```python
class PhotoBatchRequest(BaseModel):
    image_urls: list[str]
    auto_log: bool = False
```

**Output Model**:

```python
class PhotoBatchResult(BaseModel):
    total_processed: int
    food_detected: int
    non_food: int
    results: list[PhotoAnalysis]
    auto_logged: bool
```

### 6.2 FoodDiscoveryAgent

**Purpose**: Discover restaurants and recipes based on user taste profile.

**Workflow**:

1. Load user taste profile
2. Query Gemini with Google Search grounding
3. Filter and rank recommendations
4. Return personalized suggestions

**Tools Used**:

- `get_taste_profile`
- `find_nearby_food`
- `discover_restaurants`
- `discover_recipes`

### 6.3 FreshnessAgent

**Purpose**: Generate personalized daily content to keep the app feeling alive.

**Workflow**:

1. Analyze user's recent activity
2. Generate contextual content (tips, insights, achievements)
3. Include seasonal and location-aware suggestions

**Content Types**:

- Daily insights
- Streak celebrations
- Food tips of the day
- Seasonal reminders
- Achievement unlocks

### 6.4 ContentGeneratorAgent

**Purpose**: Create shareable content from food logs.

**Workflow**:

1. Aggregate food log data
2. Generate content for specified format
3. Optimize for target platform

**Content Formats**:

- Social media posts
- Blog articles
- Weekly digests
- Monthly reviews
- Recipe cards

---

## 7. Data Types

Common data types used across FCP tools and agents.

### 7.1 Meal

```json
{
  "$schema": "https://json-schema.org/draft/2020-12/schema",
  "$id": "https://fcp.fcp.dev/schema/meal.json",
  "title": "Meal",
  "type": "object",
  "properties": {
    "id": {
      "type": "string",
      "description": "Unique meal identifier"
    },
    "user_id": {
      "type": "string",
      "description": "Owner user ID"
    },
    "dish_name": {
      "type": "string",
      "description": "Name of the dish"
    },
    "cuisine": {
      "type": "string",
      "description": "Cuisine type (e.g., Italian, Japanese)"
    },
    "venue": {
      "type": "string",
      "description": "Restaurant or location name"
    },
    "notes": {
      "type": "string",
      "description": "User notes about the meal"
    },
    "image_url": {
      "type": "string",
      "format": "uri",
      "description": "URL to meal image"
    },
    "ingredients": {
      "type": "array",
      "items": {"$ref": "#/definitions/Ingredient"}
    },
    "nutrition": {
      "$ref": "#/definitions/Nutrition"
    },
    "allergens": {
      "type": "array",
      "items": {"type": "string"}
    },
    "dietary_tags": {
      "type": "array",
      "items": {"type": "string"}
    },
    "created_at": {
      "type": "string",
      "format": "date-time"
    }
  },
  "required": ["id", "user_id", "dish_name", "created_at"]
}
```

### 7.2 Nutrition

```json
{
  "$id": "https://fcp.fcp.dev/schema/nutrition.json",
  "title": "Nutrition",
  "type": "object",
  "properties": {
    "calories": {"type": "number", "minimum": 0},
    "protein_g": {"type": "number", "minimum": 0},
    "carbs_g": {"type": "number", "minimum": 0},
    "fat_g": {"type": "number", "minimum": 0},
    "fiber_g": {"type": "number", "minimum": 0},
    "sugar_g": {"type": "number", "minimum": 0},
    "sodium_mg": {"type": "number", "minimum": 0},
    "serving_size": {"type": "string"}
  }
}
```

### 7.3 Ingredient

```json
{
  "$id": "https://fcp.fcp.dev/schema/ingredient.json",
  "title": "Ingredient",
  "type": "object",
  "properties": {
    "name": {"type": "string"},
    "amount": {"type": "string"},
    "unit": {"type": "string"},
    "is_visible": {"type": "boolean", "default": true}
  },
  "required": ["name"]
}
```

### 7.4 Recipe

```json
{
  "$id": "https://fcp.fcp.dev/schema/recipe.json",
  "title": "Recipe",
  "type": "object",
  "properties": {
    "id": {"type": "string"},
    "name": {"type": "string"},
    "description": {"type": "string"},
    "cuisine": {"type": "string"},
    "prep_time_minutes": {"type": "integer"},
    "cook_time_minutes": {"type": "integer"},
    "servings": {"type": "integer"},
    "ingredients": {
      "type": "array",
      "items": {"$ref": "#/definitions/Ingredient"}
    },
    "instructions": {
      "type": "array",
      "items": {"type": "string"}
    },
    "nutrition_per_serving": {"$ref": "#/definitions/Nutrition"},
    "tags": {"type": "array", "items": {"type": "string"}},
    "image_url": {"type": "string", "format": "uri"},
    "source_url": {"type": "string", "format": "uri"}
  },
  "required": ["name", "ingredients", "instructions"]
}
```

### 7.5 TasteProfile

```json
{
  "$id": "https://fcp.fcp.dev/schema/taste-profile.json",
  "title": "TasteProfile",
  "type": "object",
  "properties": {
    "user_id": {"type": "string"},
    "favorite_cuisines": {
      "type": "array",
      "items": {"type": "string"}
    },
    "favorite_dishes": {
      "type": "array",
      "items": {"type": "string"}
    },
    "disliked_ingredients": {
      "type": "array",
      "items": {"type": "string"}
    },
    "dietary_restrictions": {
      "type": "array",
      "items": {"type": "string"}
    },
    "spice_tolerance": {
      "type": "integer",
      "minimum": 0,
      "maximum": 5
    },
    "price_preference": {
      "enum": ["budget", "moderate", "upscale", "any"]
    }
  }
}
```

---

## 8. Versioning

### 8.1 Version Format

FCP uses date-based versioning in the format `YYYY-MM-DD`.

Current version: **2026-02-04**

### 8.2 Capability Negotiation

Clients and servers negotiate capabilities during connection setup:

```json
{
  "jsonrpc": "2.0",
  "method": "initialize",
  "params": {
    "protocolVersion": "2026-02-04",
    "capabilities": {
      "tools": true,
      "agents": true,
      "voice": false
    }
  }
}
```

### 8.3 Backwards Compatibility

- New tools can be added without version bump
- Existing tool schemas are immutable within a version
- Breaking changes require new version
- Servers SHOULD support previous version for 6 months

---

## 9. Security

### 9.1 Authentication

FCP uses Firebase Authentication for user identity.

**Token Format**: Firebase ID Token (JWT)

**Header**:

```text
Authorization: Bearer eyJhbGciOiJSUzI1NiIs...
```

### 9.2 Authorization

Tools check user permissions before executing:

| Permission Level | Tools Accessible |
|-----------------|------------------|
| `read` | get_meal, get_meals, search_meals |
| `write` | add_meal, update_meal, delete_meal |
| `admin` | All tools |

### 9.3 Data Privacy

- User data is stored in isolated Firestore documents
- Image URLs are signed with expiring tokens
- No PII is logged

### 9.4 Input Validation

All tool inputs are validated against JSON Schema before execution.

### 9.5 Rate Limiting

| Endpoint Type | Rate Limit |
|--------------|------------|
| Read operations | 100/minute |
| Write operations | 30/minute |
| Analysis (Gemini) | 10/minute |

---

## 10. Error Handling

### 10.1 Error Format

```json
{
  "jsonrpc": "2.0",
  "id": "req-123",
  "error": {
    "code": -32000,
    "message": "FCP Error",
    "data": {
      "fcp_code": "FCP-101",
      "fcp_message": "Image analysis failed",
      "details": "Could not detect food in image"
    }
  }
}
```

### 10.2 Error Codes

| Code | Category | Description |
|------|----------|-------------|
| FCP-001 | Auth | Authentication required |
| FCP-002 | Auth | Invalid token |
| FCP-003 | Auth | Insufficient permissions |
| FCP-100 | Analysis | Image analysis failed |
| FCP-101 | Analysis | No food detected in image |
| FCP-102 | Analysis | Image too low quality |
| FCP-200 | Discovery | Location not found |
| FCP-201 | Discovery | No results found |
| FCP-300 | Storage | Meal not found |
| FCP-301 | Storage | Recipe not found |
| FCP-302 | Storage | Write failed |
| FCP-400 | External | Gemini API error |
| FCP-401 | External | Maps API error |
| FCP-402 | External | USDA API error |
| FCP-500 | Server | Internal server error |

### 10.3 Retry Guidance

| Error Category | Retry | Backoff |
|---------------|-------|---------|
| Auth (FCP-00x) | No | N/A |
| Analysis (FCP-1xx) | Yes | Exponential |
| Discovery (FCP-2xx) | Yes | Linear |
| Storage (FCP-3xx) | Yes | Exponential |
| External (FCP-4xx) | Yes | Exponential |
| Server (FCP-5xx) | Yes | Exponential |

---

## Appendix A: Tool Reference

See [spec/schema/tools.json](schema/tools.json) for complete tool schemas.

## Appendix B: Example Workflows

See [examples/workflows/](../examples/workflows/) for complete workflow examples.

## Appendix C: Gemini Feature Matrix

| FCP Capability | Gemini Feature | Model |
|----------------|----------------|-------|
| Image analysis | Multimodal | gemini-3-flash-preview |
| Structured extraction | Function Calling | gemini-3-flash-preview |
| Real-time data | Google Search Grounding | gemini-3-flash-preview |
| Complex reasoning | Extended Thinking | gemini-3-flash-preview |
| Recipe calculations | Code Execution | gemini-3-flash-preview |
| Video generation | Veo 3.1 | veo-3.1 |
| Voice interface | Live API | gemini-3-flash-preview |

---

## License

This specification is released under the Apache 2.0 License.

## Contributing

Contributions are welcome. Please see [CONTRIBUTING.md](../CONTRIBUTING.md) for guidelines.
