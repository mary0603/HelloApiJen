var builder = WebApplication.CreateBuilder(args);

// Explicitly bind to port 80 for Kubernetes
builder.WebHost.UseUrls("http://*:80");

var app = builder.Build();

app.MapGet("/", () => "Hello Jenkins pipline!");

app.Run();
