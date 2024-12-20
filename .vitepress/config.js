export default {
  title: 'OmniFlix Docs',
  description: 'Documentation for the omniflixhub',
  themeConfig: {
    nav: [
      { text: 'Home', link: '/' },
      { text: 'GitHub', link: 'https://github.com/OmniFlix/docs' },
    ],
    sidebar: [
      {
        text: 'Minnet Node setup',
        items: [
          { text: 'Run full node', link: '/guides/mainnet/omniflixhub-1/run-full-node.md' },
          { text: 'Create Validator', link: '/guides/mainnet/omniflixhub-1/run-validator.md' },
          { text: 'Setup cosmovisor', link: '/guides/mainnet/omniflixhub-1/cosmovisor-setup.md' },
        ],
      },
    ],
  },
};

