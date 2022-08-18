const { Plugin } = require("powercord/entities");

const {
    React,
    getModule,
    getModuleByDisplayName,
    i18n,
} = require("powercord/webpack");
const { inject, uninject } = require("powercord/injector");

const lang = require("./i18n");
const timestamps = require("./i18n/timestamps.json");

module.exports = class TokiPona extends Plugin {
    constructor() {
        super();
        this.loaded = false;
    }

    async startPlugin() {
        this.loadStrings(lang);

        const timestampModule = await getModule(
            (m) => m.default?.displayName === "MessageTimestamp"
        );

        var locale = await getModule(['updateLocaleLoadingStatus'], true);

        inject(
            "translate-timestamp",
            timestampModule,
            "default",
            (args, res) => {
                args[0].timestamp._locale = Object.assign(
                    args[0].timestamp._locale,
                    timestamps
                );

                if (!this.loaded) {
                    i18n._provider.refresh([{"locale": i18n.getLocale()}])
                    locale.updateLocaleLoadingStatus(i18n.getLocale(), false);
                    this.loaded = true;
                }
                return res;
            }
        );
    }

    loadStrings (lang) {
        const i18nContextProvider = i18n._provider?._context || i18n._proxyContext;
        let { messages, defaultMessages } = i18nContextProvider;

        Object.defineProperty(i18nContextProvider, 'messages', {
          enumerable: true,
          get: () => messages,
          set: (v) => {
            messages = Object.assign(v, lang["en-US"]);
          }
        });

        i18nContextProvider.messages = messages;
    }

    pluginWillUnload() {
        uninject("translate-timestamp");
    }
};
