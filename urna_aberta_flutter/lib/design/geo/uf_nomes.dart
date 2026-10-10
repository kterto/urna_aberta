/// UF names by TSE's lowercase code, from IBGE (`assets/geo/brasil_uf.json`).
const ufNomes = {
  'ac': 'Acre',
  'al': 'Alagoas',
  'am': 'Amazonas',
  'ap': 'Amapá',
  'ba': 'Bahia',
  'ce': 'Ceará',
  'df': 'Distrito Federal',
  'es': 'Espírito Santo',
  'go': 'Goiás',
  'ma': 'Maranhão',
  'mg': 'Minas Gerais',
  'ms': 'Mato Grosso do Sul',
  'mt': 'Mato Grosso',
  'pa': 'Pará',
  'pb': 'Paraíba',
  'pe': 'Pernambuco',
  'pi': 'Piauí',
  'pr': 'Paraná',
  'rj': 'Rio de Janeiro',
  'rn': 'Rio Grande do Norte',
  'ro': 'Rondônia',
  'rr': 'Roraima',
  'rs': 'Rio Grande do Sul',
  'sc': 'Santa Catarina',
  'se': 'Sergipe',
  'sp': 'São Paulo',
  'to': 'Tocantins',
  'zz': 'Exterior',
};

/// `br` → Brasil, a UF code → its name.
String scopeNome(String code) =>
    code == 'br' ? 'Brasil' : ufNomes[code] ?? code.toUpperCase();
