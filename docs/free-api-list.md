# Detailed Free API List (June 2026)

> Last verified: 2026-06-20
> All providers below have **FREE tier** (no credit card required unless explicitly noted)

## 🏆 Tier 1: LLM Inference (Pilih Salah Satu untuk Daily Driver)

### 1. Groq ⭐ RECOMMENDED
- **Website:** https://console.groq.com
- **Free tier:** ~500K tokens/day, unlimited requests (rate-limited)
- **Models:** Llama 3.3 70B, Llama 3.1 8B, Llama 4, Mixtral, Whisper
- **Speed:** PALING CEPAT di dunia (LPU custom)
- **Signup:** Google/GitHub OAuth, no credit card
- **Hermes config:**
  ```bash
  hermes config set model.default "groq/llama-3.3-70b-versatile"
  hermes config set model.provider groq
  echo "GROQ_API_KEY=gsk_xxxx" >> ~/.hermes/.env
  ```

### 2. NVIDIA NIM
- **Website:** https://build.nvidia.com
- **Free tier:** 1000 requests/bulan per model (rolling 30-day)
- **Models:** Nemotron Super 120B, Llama 3.1 70B, Mistral Large, DeepSeek R1
- **Quality:** SANGAT TINGGI (reasoning terbaik)
- **Signup:** Google/email, no credit card
- **Hermes config:**
  ```bash
  hermes config set model.default "nvidia/nemotron-3-super-120b-a12b"
  hermes config set model.provider nvidia
  hermes config set model.base_url "https://integrate.api.nvidia.com/v1"
  echo "NVIDIA_API_KEY=nvapi-xxxx" >> ~/.hermes/.env
  ```
- ⚠️ Endpoint update 2026-06: `integrate.api.nvidia.com/v1` (yang lama deprecated)

### 3. Cloudflare Workers AI
- **Website:** https://dash.cloudflare.com
- **Free tier:** 10,000 requests/hari (≈ 300K/bulan)
- **Models:** Llama 3.3 70B, Mistral 7B, Qwen 2.5, IBM Granite 4.0
- **Signup:** Free tier, no credit card
- **Hermes config:**
  ```bash
  hermes config set model.default "@cf/meta/llama-3.3-70b-instruct-fp8-fast"
  hermes config set model.provider cloudflare
  hermes config set model.base_url "https://api.cloudflare.com/client/v4/accounts/<ACCOUNT_ID>/ai/v1"
  echo "CLOUDFLARE_API_TOKEN=xxxx" >> ~/.hermes/.env
  echo "CLOUDFLARE_ACCOUNT_ID=xxxx" >> ~/.hermes/.env
  ```

### 4. OpenRouter
- **Website:** https://openrouter.ai
- **Free tier:** $1 signup + 50 req/hari free models
- **Models:** 100+ model dari 1 key
- **Signup:** Google/email, no credit card
- **Hermes config:**
  ```bash
  hermes config set model.default "openrouter/meta-llama/llama-3.3-70b-instruct:free"
  hermes config set model.provider openrouter
  echo "OPENROUTER_API_KEY=sk-or-xxxx" >> ~/.hermes/.env
  ```

### 5. Google AI Studio (Gemini)
- **Website:** https://aistudio.google.com
- **Free tier:** 2 req/detik, 50 req/hari
- **Models:** Gemini 2.0 Flash, Gemini 2.5 Pro
- **Hermes config:**
  ```bash
  hermes config set model.default "google/gemini-2.0-flash"
  hermes config set model.provider google
  echo "GOOGLE_API_KEY=xxxx" >> ~/.hermes/.env
  ```

### 6. Cerebras Inference
- **Website:** https://inference.cerebras.ai
- **Free tier:** 1M tokens/hari
- **Models:** Llama 3.3 70B
- **Speed:** Super cepat (CS-3 chip)

### 7. Mistral AI
- **Website:** https://console.mistral.ai
- **Free tier:** Rate-limited free tier
- **Models:** Mistral 7B, Mixtral 8x7B, Mistral Large

### 8. Cohere
- **Website:** https://dashboard.cohere.ai
- **Free tier:** 1000 req/bulan
- **Models:** Command R+, Command Light

### 9. Hugging Face Inference API
- **Website:** https://huggingface.co/settings/tokens
- **Free tier:** $0.10/hari credit (rolling)
- **Models:** Ribuan (semua open-source)
- **Hermes config:**
  ```bash
  hermes config set model.default "huggingface/meta-llama/Llama-3.3-70B-Instruct"
  hermes config set model.provider huggingface
  echo "HF_TOKEN=hf_xxxx" >> ~/.hermes/.env
  ```

### 10. GitHub Models
- **Website:** https://github.com/marketplace/models
- **Free tier:** Free untuk GitHub Copilot user
- **Models:** GPT-4o, Llama, Phi, Mistral

---

## 🎤 Tier 2: Voice (STT/TTS)

### 11. Edge TTS (Microsoft, Built-in)
- **Tier:** Unlimited
- **Lib:** `pip install edge-tts`
- **Hermes config:**
  ```bash
  hermes config set tts.provider edge
  # Tidak butuh API key
  ```

### 12. Deepgram
- **Website:** https://deepgram.com
- **Free tier:** $200 signup credit
- **Use:** STT + TTS enterprise-grade
- **Models:** Nova-2, Aura-2

### 13. ElevenLabs
- **Website:** https://elevenlabs.io
- **Free tier:** 10K chars/bulan
- **Use:** TTS voice cloning

### 14. AssemblyAI
- **Website:** https://assemblyai.com
- **Free tier:** $10 signup credit
- **Use:** STT

### 15. Local faster-whisper
- **Tier:** Unlimited (jalan di CPU/GPU lokal)
- **Lib:** `pip install faster-whisper`
- **Hermes config:**
  ```bash
  hermes config set stt.provider local
  hermes config set stt.local.model base    # tiny/base/small/medium/large-v3
  ```

---

## 🎨 Tier 3: Image / Video

### 16. Leonardo AI
- **Website:** https://leonardo.ai
- **Free tier:** 150 tokens/hari

### 17. Ideogram
- **Website:** https://ideogram.ai
- **Free tier:** Daily free quota

### 18. Fal.ai
- **Website:** https://fal.ai
- **Free tier:** $1 signup credit

### 19. Pika Labs
- **Website:** https://pika.art
- **Free tier:** Welcome credits

### 20. Luma AI
- **Website:** https://lumalabs.ai
- **Free tier:** Welcome credits

---

## 🔍 Tier 4: Search / Embedding / Scraping

### 21. Tavily
- **Website:** https://tavily.com
- **Free tier:** 1,000 credits/bulan
- **Use:** AI web search untuk agent

### 22. Firecrawl
- **Website:** https://firecrawl.dev
- **Free tier:** 500 pages/bulan
- **Use:** Web crawling untuk RAG

### 23. Voyage AI
- **Website:** https://voyageai.com
- **Free tier:** 50M tokens
- **Use:** Embedding

### 24. Jina AI
- **Website:** https://jina.ai
- **Free tier:** 1M tokens
- **Use:** Multimodal embedding + reader

---

## 💳 Tier 5: Yang PERLU Credit Card (Skip kalau mau pure free)

| Provider | Free Tier | Butuh CC? |
|----------|-----------|-----------|
| Anthropic | ❌ | - |
| OpenAI | $5 (3 bulan) | ✅ |
| Google Cloud | $300 (3 bulan) | ✅ |
| AWS | Free tier 12 bulan | ✅ |

---

## 🔐 Security Tips

1. **JANGAN share API key** di public repo / Discord / chat
2. Taruh di `~/.hermes/.env` (auto-gitignored)
3. Rotate key tiap 3-6 bulan
4. Set spending limit di dashboard provider
5. Pakai key berbeda untuk device berbeda

---

## 🆓 Strategy: 100% Free Forever

Pakai combo ini:
- **Groq** → daily driver (unlimited)
- **NVIDIA NIM** → heavy reasoning tasks (1000 req/bulan)
- **Cloudflare Workers AI** → high-volume scraping
- **Local Whisper** → STT
- **Edge TTS** → TTS

Total: $0/bulan, unlimited untuk personal use.
