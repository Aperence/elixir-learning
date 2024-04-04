# Server

To start your Phoenix server:

  * Run `mix setup` to install and setup dependencies
  * Start Phoenix endpoint with `mix phx.server` or inside IEx with `iex -S mix phx.server`

Now you can visit [`localhost:4000`](http://localhost:4000) from your browser.

Ready to run in production? Please [check our deployment guides](https://hexdocs.pm/phoenix/deployment.html).

## Learn more

  * Official website: https://www.phoenixframework.org/
  * Guides: https://hexdocs.pm/phoenix/overview.html
  * Docs: https://hexdocs.pm/phoenix
  * Forum: https://elixirforum.com/c/phoenix-forum
  * Source: https://github.com/phoenixframework/phoenix
  
## Starting on Kubernetes

See https://www.poeticoding.com/connecting-elixir-nodes-with-libcluster-locally-and-on-kubernetes/ for details about how to create a cluster inside Kubernetes, but in short:

- add [headless service](./k8s/headless-service.yaml)
- add libcluster to the [dependencies](./mix.exs)
- start a libcluster application in [./lib/server/application.ex](./lib/server/application.ex) to discover the different replicas and connect automatically to them

```bash
kubectl apply -f k8s
minikube service server # get the ip for the server
```
