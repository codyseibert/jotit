process.env.AWS_ACCESS_KEY_ID = "AKIAIAW2DXZYXGKLOVTQ"
process.env.AWS_SECRET_ACCESS_KEY = "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"

module.exports =
  BASE_URL: process.env.BASE_URL or 'http://localhost:8080'
  JWT_PASSWORD: process.env.JWT_PASSWORD or 'abc'
  # AWS_ACCESS_KEY_ID = process.env.AWS_ACCESS_KEY_ID or "AKIAIAW2DXZYXGKLOVTQ"
  # AWS_SECRET_ACCESS_KEY = process.env.AWS_SECRET_ACCESS_KEY or "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"
